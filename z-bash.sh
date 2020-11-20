export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
SCRIPT_PATH=$(dirname "$(realpath -s "${BASH_SOURCE[0]}")")

. "$SCRIPT_PATH/acd_func.sh"
. "$SCRIPT_PATH/zsh-alias.sh"
. "$SCRIPT_PATH/git-completion.sh"
. "$SCRIPT_PATH/bind.sh"

if [[ $Z_BASH_STYLE == "agnoster" ]]; then
    . $SCRIPT_PATH/agnoster-prompt.sh
else
    . $SCRIPT_PATH/plain-prompt.sh
fi

build_ps1() {
    RETVAL=$?
    # https://serverfault.com/q/97503
    # print just enough spaces and back to beginning of line
    printf "%`tput cols`s\r"
    build_prompt
}

reset_ps1() {
    PS1='$(build_ps1)'
}

reset_ps1
