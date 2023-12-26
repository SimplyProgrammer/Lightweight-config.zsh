plugins=('zsh-autosuggestions' 'zsh-completions' 'zsh-syntax-highlighting')

for plugin in "${plugins[@]}"; do
    # shellcheck disable=SC1090
    [[ -f "/usr/share/zsh/plugins/${plugin}/${plugin}.plugin.zsh" ]] \
        && source "/usr/share/zsh/plugins/${plugin}/${plugin}.plugin.zsh"
done
