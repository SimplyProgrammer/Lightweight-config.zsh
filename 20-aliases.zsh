# shellcheck disable=SC2139

#check whether we wanna use sudo or doas
root_cmds=(
    doas
    sudo
)

for cmd in "${root_cmds[@]}"; do
    if iscommand "${cmd}"; then
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

alias '??'='apropos'

alias cls='clear'
alias la='ls -a'
alias ll='ls -al'

alias - -='cd -'

alias :q='exit'

# I keep mistyping this because of colemak
alias Oqa=':qa'

iscommand apk-perma && compdef _apk apk-perma=apk

# ask for confirmation before overwrite
alias cp='cp -iv'
alias ln='ln -bv'
alias mv='mv -iv'
alias rm='rm -iv'
alias rd='rmdir'

iscommand diff && alias diff='diff --color'

if iscommand git && [[ -d ~/.files.git ]]; then
    alias dotfiles='git --git-dir=$HOME/.files.git --work-tree=$HOME'
    alias dotfiles-commit='dotfiles commit -m "$(date +%Y-%m-%d_%H:%M)"'
    compdef _git dotfiles=git
fi

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

iscommand nsxiv && alias nsxiv='nsxiv --anti-alias=no'

iscommand ssh && alias ssh='env EDITOR=vim TERM=xterm-256color ssh'

iscommand ssh-add && [[ -f ~/.ssh/id_ed25519 ]] \
    && alias ssh-add-main='ssh-add ~/.ssh/id_ed25519'

iscommand tree && alias tree='tree -C'

iscommand perl && alias perl='perl -w'

iscommand pip && alias pip='pip --require-virtualenv'

iscommand python && alias virtualenv='python -m venv'

iscommand petname && alias set-petname='export PETNAME="$(petname)"'

if iscommand yt-dlp; then
    alias yt='yt-dlp'
    compdef _yt-dlp yt=yt-dlp
fi

iscommand jj && alias jj='jj --no-pager'

iscommand jq && alias urlencode='jq -sRr @uri'

iscommand cargo \
    && alias cargo-workspace-doc='cargo doc --offline --open --target-dir ~/.cache/ --workspace'

iscommand jq wget && \
    alias am-i-mullvad='wget -O - https://am.i.mullvad.net/json | jq'

iscommand wl-paste qrencode \
    && alias qrpaste='wl-paste -n | qrencode -m 4 -t UTF8'

iscommand zig && alias zig-doc='zig std --port 37825 --no-open-browser'
