CURRENT_BG=''
# Characters
SEGMENT_SEPARATOR="\ue0b0"
BRANCH="\ue0a0"
DETACHED="\u27a6"
CROSS="\u2718"
LIGHTNING="\u26a1"
GEAR="\u2699"

prompt_section(){
    if [[ -n $CURRENT_BG ]];then
        # end the last section and draw seprator
        printf " \001\033[0m\033[3${CURRENT_BG};4$2m\002$SEGMENT_SEPARATOR\001\033[0m\002"
    fi
    # open current section
    printf "\001\033[3$1;4$2m\002 "
    CURRENT_BG=$2
}
colored_str(){
    printf "\001\033[3$1m\002$2"
}
end_prompt(){
    # still has one char dont know
    printf " \001\033[0m\033[3${CURRENT_BG}m\002$SEGMENT_SEPARATOR\001\033[0m \002"
}
# Status:
# - was there an error
# - am I root
# - are there background jobs?
status_prompt() {
    local symbols=""
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
        prompt_section 0 0
        printf "$symbols"
    fi
}
venv_prompt() {
    if [[ -n $VIRTUAL_ENV ]]; then
        prompt_section 0 6
        echo -n "$(basename $VIRTUAL_ENV)"
    fi
}
dir_prompt(){
    prompt_section 0 4
    local d_all=$(pwd)
    d_all=${d_all/$HOME/\~}
    local d_trim=$(echo $d_all | sed 's|.*\(\(/[^/]*\)\{2\}\)|\1|g' | sed 's|^/||')
    echo -n $d_trim
}
git_prompt(){
    local gps=$(__git_ps1 2>/dev/null)
    if [[ -n $gps ]]; then
        gps=${gps:2:-1}
        local clean=$(echo "$gps" | sed 's|.* .*||')

        if [[ -n $clean ]]; then prompt_section 0 2
        else prompt_section 0 3; fi

        if git symbolic-ref HEAD &> /dev/null; then printf $BRANCH
        else printf $DETACHED; fi

        echo -n ' '
        echo -n "$gps" | sed 's| ||'
    fi
}

build_prompt(){
    status_prompt
    venv_prompt
    dir_prompt
    git_prompt
    end_prompt
}
