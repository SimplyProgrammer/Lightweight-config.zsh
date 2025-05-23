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

detache() {
    detach "${@}" && exit
}
compdef _command detache

if iscommand incus; then
    incus-login() {
        local name="${1}"
        shift

        incus exec "${name}" -- sudo --user user --login -- "${@}"
    }
fi

iscommand python && venv() {
    local activate="${1}${1:+/}bin/activate"

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

    command nvim --headless --server "${NVIM}" --remote-send '<Cmd>qa<cr>'
}

iscommand nvim && nvim() {
    if [ -z "${NVIM}" ]; then
        command nvim "${@}"
        return
    fi

    ERROR="ERROR: \`$(basename "${0}") ${*}\`: already inside nvim"

    if [ ${#} -eq 0 ]; then
        echo "${ERROR}"
        return 1
    fi

    args=()
    for arg in "${@}"; do
        if [ "${arg:0:1}" = '-' ] || [ "${arg:0:1}" = '+' ]; then
            command nvim "${@}"
            return
        fi
        args+=("$(pwd)/$(basename "${arg}")")
    done

    command nvim --headless --server "${NVIM}" --remote "${args[@]}"
}

iscommand qrencode && qr() {
    printf 'input (will not echo): '
    read -rs text
    echo
    qrencode "${text}" -m 4 -t UTF8
}


iscommand ssh-add && ssh-addq() {
    NAME="${1}"
    [ "${NAME}" = "main" ] && NAME=id
    ssh-add "${HOME}/.ssh/${NAME}_ed25519"
}

iscommand ssh && sshq() {
    KEY_FILE="$(ssh -G "${1}" | grep identityfile | awk '{print $2}')"
    KEY_FILE="${KEY_FILE/\~/${HOME}}"

    if ! ssh-add -l | grep -Fq "$(ssh-keygen -lf "${KEY_FILE}")"; then
        ssh-add "${KEY_FILE}"
    fi

    ssh "${1}"
}

_which_func() {
    local func="${1}"
    shift

    if [[ $# -eq 0 ]]; then
        echo "${func}: needs at least one argument" >&2
        return 1
    fi

    local bin="$(which "${@[-1]}")"
    if [[ $? -ne 0 ]]; then
        echo "${0}: couldn't find ${@[-1]}" >&2
        return 1
    fi

    "${func}" ${@:1:-1} "${bin}"
}

wcat() {
    _which_func cat "${@}"
}
compdef _command wcat

wfile() {
    _which_func file "${@}"
}
compdef _command wfile

wstat() {
    _which_func stat "${@}"
}
compdef _command wstat

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
      elif type cmd.exe >/dev/null 2>&1; then # WSL
          cmd.exe /C $1
      else
          echo zsh command_not_found_handler: command or file not found: $@ >&2
          return 1
      fi
      return 0
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
           if [[ $file == *.lnk ]] && type cmd.exe >/dev/null 2>&1; then
              cmd.exe /C $(wslpath -w $file)
			  return 0
           fi
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
