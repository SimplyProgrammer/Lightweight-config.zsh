plugins=('zsh-autosuggestions' 'zsh-completions' 'zsh-syntax-highlighting')

for plugin in "${plugins[@]}"; do
    for subdir in '/' 'zsh/' 'zsh/plugins/'; do
        # shellcheck disable=SC1090
        [[ -f "/usr/share/${subdir}${plugin}/${plugin}.plugin.zsh" ]] \
            && source "/usr/share/${subdir}${plugin}/${plugin}.plugin.zsh"
    done
done
