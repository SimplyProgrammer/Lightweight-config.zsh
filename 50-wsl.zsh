if type cmd.exe >/dev/null 2>&1; then # Is wsl (should be sufficient)
	alias ~~="cd $HOME/Desktop"
	alias start="cmd.exe /C start"
	alias wecho="cmd.exe /C echo"
	alias wdir="cmd.exe /C dir"
	alias wping="cmd.exe /C ping"
	alias wset="cmd.exe /C set"
	alias assoc="cmd.exe /C assoc"

	zstyle ':completion:*' ignored-patterns '*.dll'
	zstyle ':completion:*' ignored-patterns '*.exe'

	# This is slow and retarded way of doing this but zsh was not cooperative...
	for winCmd in $(compgen -c | grep -F '.exe'); do
		cmd="${winCmd%%.*}"
	    alias "$cmd"="$winCmd"
	done

	# Export host/win env vars
	# cmd.exe /c set | grep -P 'home(?=.*=)' | while IFS='=' read -r var val; do
		# value=$(wslpath -u "$val" 2>/dev/null)
# 
		# if [[ $value ]]; then
			# export "$var"="$value"
		# fi
	# done
	# ^ Good concept, but terrible idea, this should be handled by wsl. Please refer to https://stackoverflow.com/questions/53365643/windows-subsystem-for-linux-not-recognizing-java-home-environmental-variable. In this particular example it is not working either...
fi
