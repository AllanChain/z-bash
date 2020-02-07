prompt_section(){
    printf "\001\033[3$1m\002 "
    printf '%s' "$2"
    printf "\001\033[0m\002"
}
temp_prompt(){
    if [ -e /sys/class/thermal/thermal_zone0/temp ]; then
        local temp=$(cat /sys/class/thermal/thermal_zone0/temp)
        local color
        if [ $temp -lt 30000 ]; then color=2
        elif [ $temp -lt 50000 ]; then color=3
        else color=1; fi
        prompt_section $color "${temp::${#temp}-3}.${temp:${#temp}-3}"
    fi
}
clock_prompt(){
    prompt_section 6 "$(date +'%H:%M:%S')"
}
user_prompt(){
    prompt_section 4 "$USER@$HOSTNAME"
}
dir_prompt(){
    local d_all=$(pwd)
    d_all=${d_all/$HOME/\~}
    prompt_section 7 "$d_all"
}
git_prompt(){
    local gps=$(__git_ps1)
    if [[ -n $gps ]]; then
        gps=${gps:2:-1}
        local clean=$(echo "$gps" | sed 's|.* .*||')

        if [[ -n $clean ]]; then prompt_section 2 "$gps"
        else prompt_section 3 "$gps"; fi
    fi
}
end_prompt(){
    if [ $RETVAL != 0 ]; then
        printf "\n\001\033[1;31m\002"
    else
        printf "\n\001\033[1;32m\002"
    fi
    printf ">\001\033[0m\002 "
}
build_prompt(){
    temp_prompt
    clock_prompt
    user_prompt
    dir_prompt
    git_prompt
    end_prompt
}
