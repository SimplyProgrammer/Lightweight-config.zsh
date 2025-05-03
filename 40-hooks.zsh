# FIX: make neovim not crash instead of adding workarounds
if [[ ${PROBABLY_IN_LXC} -eq 1 ]]; then
    function _set_title() {
        :
    }
else 
    function _set_title() {
        # setting the title inside neovim crashes it
        [[ -z ${NVIM} ]] && echo -ne "\033]0;$*\007"
    }
fi

function _title_precmd_hook() {
    _set_title "$(_current_dir) - ZSH"
}

function _title_preexec_hook() {
    # abusing xargs to trim whitespace
    _set_title "$(echo "${2}" | xargs) - ($(_current_dir)) - ZSH"
}

for name in precmd preexec; do
    eval typeset -a "${name}_functions"
    eval "${name}_functions"+=\("_title_${name}_hook"\)
done

_chpwd() {
    if zle && [[ $#BUFFER -ne 0 ]]; then
        zle .accept-line
        return
    fi

    if [[ -z "${NO_AUTO_LS}" ]]; then
        ls --color=auto -aFh
        echo
    fi

    if [[ -z "${NO_AUTO_VCS_STATUS}" ]]; then
        jj --no-pager status 2> /dev/null || git status 2> /dev/null
    fi

    if zle; then
        echo
        zle redisplay
    fi
}

chpwd_functions+=(_chpwd)
zle -N accept-line _chpwd
