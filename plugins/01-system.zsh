# shellcheck disable=SC1090
plugins=('zsh-autosuggestions' 'zsh-completions' 'zsh-syntax-highlighting')

for plugin in "${plugins[@]}"; do
    for subdir in '/' 'zsh/' 'zsh/plugins/'; do
        plugin="/usr/share/${subdir}${plugin}/${plugin}"
        [[ -f "${plugin}.plugin.zsh" ]] \
            && source "${plugin}.plugin.zsh" && break

        [[ -f "${plugin}.zsh" ]] \
            && source "${plugin}.zsh" && break
    done
done
