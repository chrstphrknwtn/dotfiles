# Symlink from ~/.oh-my-zsh/custom/

export LSCOLORS="exfxcxdxbxegedabagacad"

PROMPT='%{$fg[white]%}%c%{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%}%{$reset_color%}: '

# Time on the right
RPROMPT='%T'

ZSH_THEME_GIT_PROMPT_PREFIX="[%{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}%{$fg[red]%}:x]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}]%{$reset_color%}"
