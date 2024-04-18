[[ -n "${ZSH_EMPTY_CONFIG}" ]] \
    && exec zsh -if

command -v compdef > /dev/null || {
    autoload -Uz compinit && compinit
}

iscommand() {
    for cmd in "${@}"; do
        command -v "${cmd}" > /dev/null || return
    done
}
