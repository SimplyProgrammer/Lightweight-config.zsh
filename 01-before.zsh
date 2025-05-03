[[ -n "${ZSH_EMPTY_CONFIG}" ]] \
    && exec zsh -if

if [[ "$(cat /proc/1/cgroup)" = '0::/init.scope' ]]; then
    PROBABLY_IN_LXC=1
fi

command -v compdef > /dev/null || {
    autoload -Uz compinit && compinit
    autoload -Uz bashcompinit && bashcompinit
}

iscommand() {
    for cmd in "${@}"; do
        command -v "${cmd}" > /dev/null || return
    done
}
