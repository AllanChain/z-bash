prompt_section(){
    printf "\001\033[3$1m\002 "
    printf '%s' "$2"
    printf "\001\033[0m\002"
}
temp_prompt(){
    if [ -e /sys/class/thermal/thermal_zone0/temp ]; then
        temp=$(cat /sys/class/thermal/thermal_zone0/temp)
        if [ $temp -lt 30000 ]; then color=2
        elif [ $temp -lt 50000 ]; then color=3
        else color=1
        fi
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
    d_all=$(pwd)
    d_all=${d_all/$HOME/\~}
    prompt_section 7 "$d_all"
}
git_prompt(){
    if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
        repo_path=$(git rev-parse --git-dir 2>/dev/null)

        if [[ -e "${repo_path}/BISECT_LOG" ]]; then
          mode=" <B>"
        elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
          mode=" >M<"
        elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
          mode=" >R>"
        fi

        gps=$(__git_ps1)
        gps="${gps:2:-1}"
        if ! git diff-index --quiet HEAD 2>/dev/null; then
            # Uncommitted changes
            prompt_section 3 "${gps} ${mode}"
        else
            # Working directory clean
            prompt_section 2 "${gps} ${mode}"
        fi
    fi
}
end_prompt(){
    if [ $1 != 0 ]; then
        printf "\n\001\033[1;31m\002"
    else
        printf "\n\001\033[1;32m\002"
    fi
    printf ">\001\033[0m\002 "
}
build_prompt(){
    status=$?
    temp_prompt
    clock_prompt
    user_prompt
    dir_prompt
    git_prompt
    end_prompt $status
}

PS1='$(build_prompt)'
