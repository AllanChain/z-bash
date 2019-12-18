if [ -f /usr/share/bash-completion/completions/git ]; then
    source /usr/share/bash-completion/completions/git
fi

__git_complete gco _git_checkout
__git_complete ga _git_add
__git_complete gc _git_commit
__git_complete gd _git_diff
__git_complete gm _git_merge
__git_complete gl _git_pull
__git_complete gp _git_push
__git_complete gst _git_status
