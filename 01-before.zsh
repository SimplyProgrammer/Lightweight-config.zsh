[[ -n "${ZSH_EMPTY_CONFIG}" ]] \
    && exec zsh -if

command -v compdef > /dev/null || {
    autoload -Uz compinit && compinit
}

#function that lets us check whether a command exists
iscommand() {
    for cmd in "${@}"; do
        command -v "${cmd}" > /dev/null || return
    done
}
