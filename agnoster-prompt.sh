CURRENT_BG=''
# Characters
SEGMENT_SEPARATOR="\ue0b0"
PLUSMINUS="\u00b1"
BRANCH="\ue0a0"
DETACHED="\u27a6"
CROSS="\u2718"
LIGHTNING="\u26a1"
GEAR="\u2699"

prompt_section(){
    if [[ -n $CURRENT_BG ]];then
        # end the last section and draw seprator
        printf " \001\033[0m\033[3${CURRENT_BG};4$2m\002\001\033[0m\002"
    fi
    # open current section
    printf "\001\033[3$1;4$2m\002 "
    # still has one char dont know
    CURRENT_FG=$1
    CURRENT_BG=$2
}
colored_str(){
    printf "\001\033[3$1m\002$2"
}
end_prompt(){
    printf " \001\033[0m\002\001\033[3${CURRENT_BG}m\002\001\033[0m\002 "
}
# Status:
# - was there an error
# - am I root
# - are there background jobs?
status_prompt() {
    symbols=""
    if [[ $RETVAL -ne 0 ]]; then
        symbols="$symbols$(colored_str 1 $CROSS)"
    fi
    if [[ $UID -eq 0 ]]; then
        symbols="$symbols$(colored_str 3 $LIGHTNING)"
    fi
    if [[ $(jobs -l | wc -l) -gt 0 ]]; then
        symbols="$symbols$(colored_str 6 $GEAR)"
    fi

    if [[ -n "$symbols" ]]; then
        prompt_section 0 7
        printf "$symbols"
    fi
}
dir_prompt(){
    prompt_section 0 4
    d_all=$(pwd)
    d_all=${d_all/$HOME/\~}
    # printf "$d_all"
    d_trim=$(echo $d_all | sed 's|.*\(\(/[^/]*\)\{2\}\)|\1|g' | sed 's|^/||')
    echo -n $d_trim
}
git_prompt(){
    if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
        if git symbolic-ref HEAD &> /dev/null;then
            symbol=''
        else
            symbol='➦'
        fi

        gps=$(__git_ps1)
        gps="${gps:2:-1}"
        if ! git diff-index --quiet HEAD 2>/dev/null; then
            # Uncommitted changes
            prompt_section 0 3
        else
            # Working directory clean
            prompt_section 0 2
        fi
        printf "${symbol} ${gps}${mode}"
    fi
}

build_prompt(){
    RETVAL=$?
    status_prompt
    dir_prompt
    git_prompt
    end_prompt
}

PS1='$(build_prompt)'
