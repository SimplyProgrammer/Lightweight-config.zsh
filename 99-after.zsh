GPG_TTY="$(tty)"
export GPG_TTY

iscommand direnv && eval "$(direnv hook zsh)"

# set the status code to 0 if it's something else
true
