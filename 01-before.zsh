[[ -n "${ZSH_EMPTY_CONFIG}" ]] \
    && exec zsh -if

command -v compdef > /dev/null || {
    autoload -Uz compinit && compinit
    autoload -Uz bashcompinit && bashcompinit
}

iscommand() {
    for cmd in "${@}"; do
        command -v "${cmd}" > /dev/null || return
    done
}
