GPG_TTY="$(tty)"
export GPG_TTY

iscommand direnv && eval "$(direnv hook zsh)"
