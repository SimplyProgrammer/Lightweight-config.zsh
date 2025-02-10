# Lightweight-config.zsh
Lightweight yet powerful zsh configuration. If you are using bash, you are going to love this...
## Notable features:
* Prompt coloring
* Tab completions (including flags)
* Smart suggestions
* Easy navigation, no cd needed
* And more...
<be>

"Silent" fork of https://git.sr.ht/~ashie/config.zsh
<be>

## Additional features:
* Some aliases
* Easy file opening:
  * When you type a file name into the shell, instead of printing "invalid command", it will open the file in your favorite editor. Providing that the file exists.
  * The same will occur when you type a path to a valid file that can't be executed (no x permission). For example, typing /etc/hosts will open hosts in your favorite editor. If /etc/hosts would not exist for some reason you will be given an option to create it including the path and edit it subsequently! Especially useful in scenarios where you are root most of the time...
* Simplified build process. Only a few external dependencies, no o-my-zsh required...

## Install
It should be compatible with any POSIX-compliant system that supports zsh.
Only git is required (End pressing Y couple of times).
```
mkdir -p ~/.config/zsh/config.zsh && cd "$_" && git clone "https://github.com/SimplyProgrammer/Lightweight-config.zsh.git" . && chmod 755 build.sh setup-all.sh && ./setup-all.sh
```
^ This works only for Debian-based Linux distros but that is largely because of `apt install` in setup-all.sh which other distros likely will not support, you can change this to your specific package manager and it should work... 
