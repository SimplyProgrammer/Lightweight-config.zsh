# shellcheck disable=SC2016,SC2034
HISTFILE="${HOME}/.zsh_history"
HISTORY_IGNORE='(ls|history|hist|-|..|_)'
HIST_STAMPS='dd.mm.yyyy'
HISTSIZE=50000
SAVEHIST=10000

#timer plugin
TIMER_FORMAT='[%d]'
TIMER_PRECISION=2
TIMER_THRESHOLD=1

HYPHEN_INSENSITIVE=true

COMPLETION_WAITING_DOTS='true'

unsetopt menu_complete
unsetopt flowcontrol

zsh_options=(
    always_to_end
    auto_cd
    auto_pushd
    auto_menu
    cdable_vars
    complete_aliases
    complete_in_word
    correct
    extended_history
    hist_append
    hist_expire_dups_first
    hist_ignore_dups
    hist_ignore_space
    hist_reduce_blanks
    hist_save_no_dups
    hist_verify
    inc_append_history
    prompt_subst
    pushdminus
    pushd_ignore_dups
    share_history
)

for option in "${zsh_options[@]}"; do
    setopt "${option}"
done

unset zsh_options
