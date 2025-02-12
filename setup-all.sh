#!/bin/bash

# apt install git  is required...
# download zsh-users plugins
echo Installing...

plugins=('zsh-autosuggestions' 'zsh-completions' 'zsh-syntax-highlighting')

if command -v sudo &>/dev/null; then
    SUDO="sudo"
else
    SUDO=""
fi

$SUDO apt install -y zsh

for plugin in "${plugins[@]}"; do
    $SUDO git clone "https://github.com/zsh-users/${plugin}" "/usr/share/zsh/plugins/${plugin}"
done

$SUDO ./build.sh

$SUDO chsh -s "$(which zsh)" "$(whoami)"
cp -rf .zshrc "$HOME/"
cp -rf .zprofile "$HOME/"
chmod u+x "$HOME/.zshrc" "$HOME/.zprofile"
exec zsh
