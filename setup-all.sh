#!/bin/bash

# apt install git  is required...
# download zsh-users plugins
echo Installing...

plugins=('zsh-autosuggestions' 'zsh-completions' 'zsh-syntax-highlighting')

apt install zsh
for plugin in "${plugins[@]}"; do
	  git clone "https://github.com/zsh-users/${plugin}" "/usr/share/zsh/plugins/${plugin}"
done

./build.sh
chsh -s $(which zsh)
cp -rf .zshrc ~/
cp -rf .zprofile ~/
cd ~ && chmod u+x .zshrc .zprofile
zsh
