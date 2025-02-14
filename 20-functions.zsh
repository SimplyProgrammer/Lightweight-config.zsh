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

function __fav_file_editor() {
   # Open in fav editor...
   if [ -n "$VISUAL" ]; then
      $VISUAL "$@"
   elif [ -n "$EDITOR" ]; then
      $EDITOR "$@"
   elif type sensible-editor >/dev/null 2>/dev/null; then
      sensible-editor "$@"
   elif type update-alternatives >/dev/null 2>/dev/null; then
      $(update-alternatives --query editor | awk '/Value:/ {print $2}') "$@"
   fi
}
alias e="__fav_file_editor"

command_not_found_handler() {
   if [[ -o interactive ]]; then # Kinda retarded
      if [[ -w $1 ]]; then # Command does not exist but file does...
          __fav_file_editor $1
          return 0
      elif type cmd.exe >/dev/null 2>&1; then
          cmd.exe /C $1
      else
          echo zsh command_not_found_handler: command or file not found: $@ >&2
          return 1
      fi
   fi
}

preexec() {
    REAL_LAST_CMD="$1"
}


TRAPZERR() {
    local exit_status=$?
    local file=$(echo "$REAL_LAST_CMD" | awk '{print $1}')

    if [[ $exit_status -eq 126 ]]; then # No permission
        #exec &2>/dev/null

        if [[ -f "$file" ]]; then
           __fav_file_editor $file
           return 0
        fi
    elif [[ $exit_status -eq 127 ]]; then # Does not exist
        if [[ -f "$file" ]]; then
            return 0 # Should not happen
        fi

        local dir=$(dirname $file)
        if read -q "choice?Do you want to create $file? [y/N] "; then
           mkdir -p $dir && touch $file
           __fav_file_editor $file
           return 0
        fi
    fi
}
