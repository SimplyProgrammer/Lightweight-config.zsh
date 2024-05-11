# shellcheck disable=SC2139

#check whether we wanna use sudo or doas
root_cmds=(
    doas
    sudo
    'su -c'
)

for cmd in "${root_cmds[@]}"; do
    if iscommand "${cmd% *}"; then
        GET_ROOT="${cmd}"
        break
    fi
done

unset root_cmds

if [[ -n "${GET_ROOT}" ]]; then
    #so sudo/doas works with aliases
    alias "${GET_ROOT}"="${GET_ROOT} "

    alias _="${GET_ROOT} "
    compdef "_${GET_ROOT}" _="${GET_ROOT}"
fi

alias - -='cd -'

alias :q='exit'

# I keep mistyping this because of colemak
alias Oqa=':qa'

# ask for confirmation before overwrite
alias cp='cp -iv'
alias ln='ln -bv'
alias mv='mv -iv'
alias rm='rm -iv'
alias rd='rmdir'

iscommand diff && alias diff='diff --color'

if iscommand rg; then
    alias grep='rg -i'
else
    alias grep='grep -i --color=auto'
fi

alias history='omz_history -E'
alias hist='history 0 | grep --'

alias ls='ls --color=auto -Fh'

alias mk='mkdir'
compdef _mkdir mk=mkdir

alias mkdir='mkdir -v'

iscommand ncdu && alias ncdu='ncdu --color dark'

iscommand nmcli && alias nmcli='nmcli --pretty'

if iscommand nvim; then
    alias vi='nvim'
    alias vim='nvim'
fi

iscommand ssh && alias ssh='env -i EDITOR=vim TERM=xterm-256color ssh'

iscommand tree && alias tree='tree -C'

if iscommand yt-dlp; then
    alias yt='yt-dlp'
    compdef _yt-dlp yt=yt-dlp
fi

iscommand cargo \
    && alias cargo-workspace-doc='cargo doc --offline --open --target-dir ~/.cache/ --workspace'

iscommand wl-paste qrencode \
    && alias qrpaste='wl-paste -n | qrencode -m 4 -t UTF8'

iscommand zig && alias zig-doc='zig std --port 37825 --no-open-browser'
