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
    [[ ! -L "$HOME/$link" ]] && echo "/mnt/c/Users/$winUser/$link <- $HOME/$link" && ln -s "/mnt/c/Users/$winUser/$link" "$HOME/$link"
done

# .folders from win user. Only .folders, .files may cause conflicts 
for path in $(find "/mnt/c/Users/$winUser/" -maxdepth 1 -type d -name ".*" ! -name "* *"); do
	file=$(basename $path)
    [[ ! -L "$HOME/$file" ]] && echo "$path <- $HOME/$file" && ln -s "$path" "$HOME/$file"
done
