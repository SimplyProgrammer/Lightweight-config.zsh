# shellcheck disable=SC2016

ZSH_THEME_GIT_PROMPT_PREFIX="‹%F{yellow}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f› "
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

_venv_prompt_info() {
    if [[ -n ${VIRTUAL_ENV} ]]; then
        printf '<%%F{green}%s%%f>' "${VIRTUAL_ENV:t:gs/%/%%}"
    elif [[ -f bin/activate ]]; then
        printf '<%%F{yellow}!%s%%f>' "${PWD:t:gs/%/%%}"
    fi
}

# disables prompt mangling in virtual_env/bin/activate
export VIRTUAL_ENV_DISABLE_PROMPT=1

_ssh_before_prompt() {
    [[ -n "${SSH_CONNECTION}" ]] \
        && printf '%%F{yellow}ssh://%%f'
}

_ssh_after_prompt() {
    [[ -n "${SSH_CONNECTION}" ]] || return
    printf '@'
    printf '%s' "${SSH_CONNECTION}" | awk '{print $3}'
}

_current_dir() {
    local color='%F{blue}'
    [[ -w "${PWD}" ]] || color='%F{red}'

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

    echo -n "%B${color}${path}%f%b"
}

PROMPT=''
prompt_parts=(
    '╭─'
    '$(_ssh_before_prompt)'
    '%B%(!.%F{red}.%F{green})%n%f%b'
    '$(_ssh_after_prompt)'
    ' $(_current_dir)'
    ' $(git_prompt_info)'
    '$(_venv_prompt_info)'
    $'\n╰─%B%(!.#.$)%b '
)

for part in "${prompt_parts[@]}"; do
    PROMPT="${PROMPT}${part}"
done

RPROMPT='%B%F{red}%(?..%? ↵)%f%b'
