# shellcheck disable=SC2016

ZSH_THEME_GIT_PROMPT_PREFIX="‹%F{yellow}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f› "
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

_venv_prompt_info() {
    if [[ -n ${VIRTUAL_ENV} ]]; then
        local venv
        venv="$(basename "${VIRTUAL_ENV}")"

        if [[ "${venv}" = 'venv' ]]; then
            venv="$(basename "$(dirname "${VIRTUAL_ENV}")")"
        fi

        printf '<%%F{green}%s%%f>' "${venv}"
    elif sh -c 'export DIR="$(pwd)"; while [ "$(realpath "${DIR}")" != '/' ]; do [ -f "${DIR}/bin/activate" ] && { exit 0; break; }; DIR="${DIR}/.."; done; exit 1' || 
        [[ -f venv/bin/activate ]]
    then
        # the thing above does not work in zsh
        printf '<%%F{yellow}!%s%%f>' "${PWD:t:gs/%/%%}"
    fi
}

# disables prompt mangling in virtual_env/bin/activate
export VIRTUAL_ENV_DISABLE_PROMPT=1

_ssh_before_prompt() {
    [[ -n "${SSH_CONNECTION}" ]] \
        && echo -n '%F{yellow}ssh://%f'
}

_user_prompt() {
    local name
    if [[ ${PROBABLY_IN_LXC} -eq 1 ]]; then
        echo -n '%F{cyan}lxc:%f'
        name='%m'
    else
        name='%n'
    fi
    echo -n '%(!.%F{red}.%F{green})'
    echo -n "${name}"
    echo -n '%f%b'
}

_ssh_after_prompt() {
    [[ -n "${SSH_CONNECTION}" ]] || return
    printf '@'
    printf '%s' "${SSH_CONNECTION}" | awk '{print $3}'
}

_current_dir_prompt() {
    local color='%F{blue}'
    [[ -w "${PWD}" ]] || color='%F{red}'

    echo -n "%B${color}$(_current_dir)%f%b"
}

PROMPT=''
prompt_parts=(
    '╭─'
    '$(_ssh_before_prompt)'
    '%B$(_user_prompt)'
    '$(_ssh_after_prompt)'
    ' $(_current_dir_prompt)'
    ' $(git_prompt_info)'
    '$(_venv_prompt_info)'
    $'\n╰─%B%(!.#.$)%b '
)

for part in "${prompt_parts[@]}"; do
    PROMPT="${PROMPT}${part}"
done

RPROMPT='%B%F{red}%(?..%? ↵)%f%b'
