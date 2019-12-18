SCRIPT_PATH=$(dirname "$(realpath -s "${BASH_SOURCE[0]}")")

. $SCRIPT_PATH/zsh-alias.sh
. $SCRIPT_PATH/git-completion.sh

if [[ $Z_BASH_STYLE == "agnoster" ]]; then
    . $SCRIPT_PATH/agnoster-prompt.sh
else
    . $SCRIPT_PATH/plain-prompt.sh
fi
