#!/usr/bin/env zsh

# apt install git  is required...
# download zsh-users plugins
echo Installing...

plugins=('zsh-autosuggestions' 'zsh-completions' 'zsh-syntax-highlighting')

apt install zsh
for plugin in "${plugins[@]}"; do
	  mkdir -p  && cd "$_" && git clone "https://github.com/zsh-users/${plugin}" "/usr/share/zsh/plugins/${plugin}"
done

./build.sh
grep -qxF "ZDOTDIR=$(pwd)" /etc/zsh/zshenv || echo "ZDOTDIR=$(pwd)" >> /etc/zsh/zshenv # Doing this manually might be required on some systems...
chsh -s $(which zsh)
zsh
