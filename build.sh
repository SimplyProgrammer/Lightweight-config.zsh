#!/usr/bin/env zsh

set -ex

cd "$(dirname "${0}")"
cat ./plugins/*.zsh > 10-plugins-generated.zsh
cat ./*.zsh > .zshrc
zcompile .zshrc
rm 10-plugins-generated.zsh .zshrc
