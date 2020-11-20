# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'
bind '"\e[Z":menu-complete'
bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'

if [[ $BASH_VERSION > "2.05a" ]]; then
  # ctrl+w shows the menu
  bind -x "\"\C-w\":cd_func -- ;"
fi
