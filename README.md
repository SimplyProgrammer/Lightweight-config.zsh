# Lightweight-config.zsh
Lightweight yet powerful zsh configuration. If you are using bash, you are going to love this...
## Notable features:
* Prompt coloring
* Tab completions (including flags)
* Smart suggestions
* Easy navigation, no cd needed
* And more...
<br>

"Silent" fork of https://git.sr.ht/~ashie/config.zsh or https://codeberg.org/ashie/config.zsh (neither of those can be forked to GitHub but all props to them...)
<br>

## Additional features:
* Some aliases
* Easy file opening:
  * When you type a file name into the shell, instead of printing "invalid command", it will open the file in your favorite editor. Providing that the file exists.
  * The same will occur when you type a path to a valid file that can't be executed (no x permission). For example, typing /etc/hosts (or e /etc/hosts) will open hosts in your favorite editor. If /etc/hosts would not exist for some reason you will be given an option to create it including the path and edit it subsequently! Especially useful in scenarios where you are root most of the time...
* Simplified build process. Only a few external dependencies, no o-my-zsh required...
* Partial Windows Subsystem for Linux (WSL) integration:
  * You can run 99% of Windows commands like if they were native Linux commands, without necessity of writing .exe at the end, for example, `ipconfig` or `assoc`. But 90% of the times, completions and suggestions will not will not work with Windows commands.
  * Some commands that are same on both Windows and Linux are aliased with 'w' prefix, for example `wping`, `wecho` or `wset`.
  * Support for opening .lnk files (windows symlinks) in a "windows friendly" fashion.

## Install
It should be compatible with any POSIX-compliant system that supports zsh.
Only git is required.
```bash
mkdir -p ~/.config/zsh/config.zsh && cd "$_" && git clone "https://github.com/SimplyProgrammer/Lightweight-config.zsh.git" . && chmod 755 build.sh setup-all.sh && ./setup-all.sh
```
^ This works only for Debian-based Linux distros but that is largely because of `apt install` in setup-all.sh which other distros likely will not support, you can change this to your specific package manager and it should work... 

^ If this refuses to run with error saying something like `/bin/bash^M` does not exist, you likely need to "de-DOSify" the line breaks with:
```bash
find ./ -type f -exec dos2unix {} +
```
<br>

For WSL you should also run `prep-wsl.sh` after running `setup-all.sh`.
