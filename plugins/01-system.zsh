# shellcheck disable=SC1090
plugins=('zsh-autosuggestions' 'zsh-completions' 'zsh-syntax-highlighting')

for plugin in "${plugins[@]}"; do
    for subdir in '/' 'zsh/' 'zsh/plugins/'; do
        plugin_path="/usr/share/${subdir}${plugin}/${plugin}"
        [[ -f "${plugin_path}.plugin.zsh" ]] \
            && source "${plugin_path}.plugin.zsh" && break

        [[ -f "${plugin_path}.zsh" ]] \
            && source "${plugin_path}.zsh" && break
    done
done
