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

KEYTIMEOUT=1

HYPHEN_INSENSITIVE=true

COMPLETION_WAITING_DOTS='true'

unsetopt MENU_COMPLETE
unsetopt FLOWCONTROL

zsh_options=(
    ALWAYS_TO_END
    AUTO_CD
    AUTO_PUSHD
    AUTO_MENU
    CDABLE_VARS
    COMPLETE_ALIASES
    COMPLETE_IN_WORD
    CORRECT
    EXTENDED_HISTORY
    HIST_APPEND
    HIST_EXPIRE_DUPS_FIRST
    HIST_IGNORE_DUPS
    HIST_IGNORE_SPACE
    HIST_REDUCE_BLANKS
    HIST_SAVE_NO_DUPS
    HIST_FIND_NO_DUPS
    HIST_VERIFY
    INC_APPEND_HISTORY
    PROMPT_SUBST
    PUSHDMINUS
    PUSHD_IGNORE_DUPS
    SHARE_HISTORY
)

for option in "${zsh_options[@]}"; do
    setopt "${option}"
done

unset zsh_options
