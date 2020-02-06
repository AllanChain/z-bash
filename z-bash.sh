export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
SCRIPT_PATH=$(dirname "$(realpath -s "${BASH_SOURCE[0]}")")

. $SCRIPT_PATH/acd_func.sh
. $SCRIPT_PATH/zsh-alias.sh
. $SCRIPT_PATH/git-completion.sh

if [[ $Z_BASH_STYLE == "agnoster" ]]; then
    . $SCRIPT_PATH/agnoster-prompt.sh
else
    . $SCRIPT_PATH/plain-prompt.sh
fi

# https://serverfault.com/q/97503
# print just enough spaces and back to beginning of line
PS1='$(printf "%`tput cols`s\r")'"$PS1"
# PS1='$(printf "%$((`tput cols`-1))s\r")'"$PS1"
