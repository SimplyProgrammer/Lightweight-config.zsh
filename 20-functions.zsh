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

cc() {
    # shellcheck disable=2296
    ${(z)CC:-gcc} -ggdb -Wall -Wextra "${@}"
}

detach() {
    (nohup "${@}" < /dev/null > /dev/null 2>&1 &)
}
compdef _command detach

iscommand pip && pip() {
    if [[ -z "${VIRTUAL_ENV}" ]]; then
        echo "${0}: use outside virtualenv prohibited" >&2
        return 1
    fi

    command pip "${@}"
}

iscommand virtualenv && venv() {
    if [[ "${#}" -eq 1 ]]; then
        source "${1}/bin/activate"
    else
        source bin/activate
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
