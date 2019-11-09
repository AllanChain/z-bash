prompt_section(){
    printf "\001\033[3$1m\002 "
    printf "$2"
    printf " \001\033[0m\002"
}
end_prompt(){
    prompt_section 4 "\n\001\033[1;32m\002>\001\033[0m\002 "
}
dir_prompt(){
    d_all=$(pwd)
    d_all=${d_all/$HOME/\~}
    prompt_section 4 "$d_all"
}
git_prompt(){
    if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
        repo_path=$(git rev-parse --git-dir 2>/dev/null)
        ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="$(git rev-parse --short HEAD 2> /dev/null)"
        ref=${ref/refs\/heads\//}

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
            git_now="${git_now}*";
        fi
        if [[ "$git_status" =~ Changes\ to\ be\ committed ]]; then
            git_now="${git_now}+";
        fi
        if [[ "$git_status" =~ Your\ branch\ is\ ahead ]]; then
            git_now="${git_now}^";
        fi
        if [[ "$git_status" =~ nothing\ to\ commit ]]; then
            prompt_section 2 "${ref} ${git_now}${mode}"
        else
            prompt_section 3 "${ref} ${git_now}${mode}"
        fi
    fi
}

user_prompt(){
    prompt_section 5 "$USER@$HOSTNAME"
}

build_prompt(){
    user_prompt
    dir_prompt
    git_prompt
    end_prompt
}

#PS1='\[\033[30;44m\] \w \[\033[0m\]$(build_prompt)$(dir_prompt)'
PS1='$(build_prompt)'
