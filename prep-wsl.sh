#!/bin/bash

# Setup for wsl, run this manually.

if ! type cmd.exe >/dev/null 2>&1; then
	echo "Windows Subsystem for Linux (WSL) setup cant be performed in non-WSL environments!"
	exit 1
fi

winUser=$1
if [[ -z "$winUser" ]]; then
    winUser=$(cmd.exe /c set | grep -P 'USERNAME' | cut -c 10- | tr -d '\r')
fi

if [[ ! ":$PATH:" == *:/mnt/c/Windows/system32:* ]]; then
    export PATH=$PATH:/mnt/c/Windows/system32
fi

#echo $HOME
links=('Desktop' 'Documents' 'Downloads')

for link in "${links[@]}"; do
	echo "/mnt/c/Users/$winUser/$link <- $HOME/$link"

    [[ ! -L "$HOME/$link" ]] && ln -s "/mnt/c/Users/$winUser/$link" "$HOME/$link"
done

