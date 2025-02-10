function _set_title() {
    # setting the title inside neovim crashes it
    [[ -z ${NVIM} ]] && echo -ne "\033]0;$*\007"
}

function _title_precmd_hook() {
    _set_title "$(_current_dir) - ZSH"
}

function _title_preexec_hook() {
    # abusing xargs to trim whitespace
    _set_title "$(echo "${2}" | xargs) - ($(_current_dir)) - ZSH"
}

for name in precmd preexec
do
    eval typeset -a "${name}_functions"
    eval "${name}_functions"+=\("_title_${name}_hook"\)
done
