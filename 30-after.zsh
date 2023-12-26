GPG_TTY="$(tty)"
export GPG_TTY

eval "$(ssh-agent)" > /dev/null
