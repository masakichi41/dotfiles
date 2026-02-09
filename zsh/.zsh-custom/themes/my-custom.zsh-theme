local ret_status="%(?:%{$fg_bold[green]%}$ :%{$fg_bold[red]%}$ )"
PROMPT=$'%{$fg[green]%}%n: %{$reset_color%}%{$fg[blue]%}%~ %{$fg_bold[blue]%}$(git_prompt_info)%{$reset_color%}
${ret_status}%{$reset_color%}'
RPROMPT=''
PROMPT2="%{$fg_bold[black]%}%_> %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
