CURRENT_BG=''
prompt_section(){
    #local fg bg
    if [[ -n $CURRENT_BG ]];then
        # end the last section and draw seprator
        printf " \001\033[0m\002\001\033[3${CURRENT_BG};4$2m\002\001\033[0m\002"
    fi
    # open current section
    printf "\001\033[3$1;4$2m\002 "
    # still has one char dont know
    export CURRENT_BG=$2
}
end_prompt(){
    printf " \001\033[0m\002\001\033[3${CURRENT_BG}m\002\001\033[0m\002 "
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
        repo_path=$(git rev-parse --git-dir 2>/dev/null)
        ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"
        ref=${ref/refs\/heads\// }

        if [[ -e "${repo_path}/BISECT_LOG" ]]; then
          mode=" <B>"
        elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
          mode=" >M<"
        elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
          mode=" >R>"
        fi

        local git_status=$(git status)
        local git_now; # 标示
        if [[ "$git_status" =~ Changes\ not\ staged || "$git_status" =~ no\ changes\ added ]]; then
            git_now="${git_now}●";
        fi
        if [[ "$git_status" =~ Changes\ to\ be\ committed ]]; then
            git_now="${git_now}✚";
        fi
        if [[ "$git_status" =~ Untracked\ files ]]; then
            git_now="${git_now}+";
        fi
        if [[ "$git_status" =~ Your\ branch\ is\ ahead ]]; then
            git_now="${git_now}↑";
        fi
        if [[ "$git_status" =~ nothing\ to\ commit ]]; then
            prompt_section 0 2 
        else
            prompt_section 0 3
        fi
        printf "${ref} ${git_now}${mode}"
    fi
}

build_prompt(){
    dir_prompt
    git_prompt
    end_prompt
}

PS1='$(build_prompt)'
