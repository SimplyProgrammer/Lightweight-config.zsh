GIT_SUBREPO_RC="${HOME}/.local/share/git-subrepo/.rc"
[ -f "${GIT_SUBREPO_RC}" ] && \
    NO_AUTO_LS=1 NO_AUTO_VSC_STATUS=1 source ~/.local/share/git-subrepo/.rc
