if type cmd.exe >/dev/null 2>&1; then # Is wsl (should be sufficient)
	alias ~~="cd $HOME/Desktop"
	alias cmdc="cmd.exe /C"
	alias start="cmdc start"
	alias wecho="cmdc echo"
	alias wdir="cmdc dir"
	alias wping="cmdc ping"
	alias wset="cmdc set"
	alias wfind="cmdc find"
	alias assoc="cmdc assoc"

	zstyle ':completion:*' ignored-patterns '*.dll'
	zstyle ':completion:*' ignored-patterns '*.exe'

	# This is slow and retarded way of doing this but it kills multiple flies in on swing and zsh hooks are too retarded for this...
	declare -A winCmdsCache
	while IFS= read -r cmd; do
	    winCmdsCache["$cmd"]=1
	done < <(compgen -c)

	for winCmd in $(compgen -c | grep -F '.exe'); do
	# compgen -c | grep -F '.exe' | while IFS= read -r winCmd; do
	    cmd="${winCmd%%.*}"
	
	    if [[ -n "${winCmdsCache[$cmd]}" ]]; then
	        alias "w$cmd"="$winCmd"
	    else
	        alias "$cmd"="$winCmd"
	    fi
	done
	
	unalias find >/dev/null 2>&1

	type mvn >/dev/null 2>&1 && alias mvn="cmdc mvn"
	type gradle >/dev/null 2>&1 && alias gradle="cmdc gradle"
	type python >/dev/null 2>&1 && alias python="cmdc python"

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
