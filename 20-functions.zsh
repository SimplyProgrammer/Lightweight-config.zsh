#go up several directories, (.. 3 == ../../../)
..() {
    if [[ "${#}" -gt 1 ]]; then
        echo "${0}: too many arguments"
        return 1
    fi

    local limit="${1:-1}"
    if [[ "${limit}" -le 0 ]]; then
        echo "${0}: '${1}' must be an integer higher than 0"
        return 1
    fi

    local dir=""
    for ((i = 1; i <= limit; i++)); do
        dir="../${dir}"
    done

    cd "${dir}" || return 1
}

iscommand apk && apk() {
    command apk "${@}" && rehash
}

cc() {
    # shellcheck disable=2296
    ${(z)CC:-gcc} -ggdb -Wall -Wextra "${@}"
}

# shellcheck disable=1009,1035,1072,1073
detach() {
    "${@}" > /dev/null 2>&1 &!
}
compdef _command detach

iscommand incus && incus-login() {
    local name="${1}"
    shift

    incus exec "${name}" -- sudo --user user --login -- "${@}"
}

iscommand pip && pip() {
    if [[ -z "${VIRTUAL_ENV}" ]]; then
        echo "${0}: use outside virtualenv prohibited" >&2
        return 1
    fi

    command pip "${@}"
}

iscommand python && venv() {
    local activate="${1}${1+:/}bin/activate"

    if [[ -f "${activate}" ]]; then
        source "${activate}"
    elif [[ "${#}" -eq 0 ]] && [[ -f "venv/${activate}" ]]; then
        source "venv/${activate}"
    else
        echo "${0}: no such file or directory '${activate}'"
    fi
}

not() {
    "${@}" || return 0
    return 1
}

:qa() {
    [[ -z "${NVIM}" ]] && exit

    /usr/bin/nvim --headless --server "${NVIM}" --remote-send '<Cmd>qa<cr>'
}

iscommand qrencode && qr() {
    printf 'input (will not echo): '
    read -rs text
    echo
    qrencode "${text}" -m 4 -t UTF8
}

wcat() {
    if [[ $# -ne 1 ]]; then
        echo "${0}: needs exactly one argument" >&2
        return 1
    fi

    cat "$(which "${1}")"
}
compdef _command wcat

_current_dir() {
    local path="${PWD/#${HOME}/~}"

    if [[ "${path}" != "~" ]]; then
        local prefix=""
        for segment in "${(s./.)path:h}"; do
            if [[ -z "$segment" ]]; then
                prefix="/"
                continue
            fi

            if [[ "${segment:0:1}" = "." ]]; then
                prefix="${prefix}${segment:0:2}/"
            else
                prefix="${prefix}${segment:0:1}/"
            fi
        done
        path="${prefix}${path:t}"
    fi

    echo -n "${path}"
}

