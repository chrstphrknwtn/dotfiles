# -----------------------------------------------------------------------------
# zsh prompt

source $HOME/.zsh/antigen/antigen.zsh
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle rupa/z
antigen apply

# pure prompt
fpath=( "$HOME/.zfunctions" $fpath )
autoload -U promptinit; promptinit
prompt pure

# -----------------------------------------------------------------------------
# zsh options

setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt share_history
setopt ignoreeof

HISTFILE=$HOME/.zsh_history
HISTSIZE=200000
SAVEHIST=100000

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search

# mkdir -p $HOME/.z.data
_Z_DATA=$HOME/.z.data/.z

# -----------------------------------------------------------------------------
# zle shortcuts

searchup() {
  zle up-line-or-beginning-search
  _zsh_highlight
}
searchdown() {
  zle down-line-or-beginning-search
  _zsh_highlight
}

zle -N up-line-or-beginning-search
zle -N searchup
bindkey "^[[A" searchup

zle -N down-line-or-beginning-search
zle -N searchdown
bindkey "^[[B" searchdown

# z style
zstyle ':completion:*:*:*:*:*' menu select

# -----------------------------------------------------------------------------
# less (man pages) color / style

# Bold Mode
export LESS_TERMCAP_md=$'\E[37m' # white
export LESS_TERMCAP_me=$'\E[38;5;248m' # grey

# Standout Mode
export LESS_TERMCAP_so=$'\E[47m\E[30m' # black on white
export LESS_TERMCAP_se=$'\E[0m' # reset all

# Underline Mode
export LESS_TERMCAP_us=$'\E[4m' # underline
export LESS_TERMCAP_ue=$'\E[38;5;248m\E[24m' # grey; reset underline

# -----------------------------------------------------------------------------
# Aliases

# ls
alias l="lm" #https://github.com/chrstphrknwtn/lm
alias ll="ls -lahG"

# Flush DNS
alias flushdns="sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder"

# Hidden Files
alias show='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hide='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

# .git suffix: paste raw ssh git url to clone
alias -s git='git clone'

# Git conveniences
GIT_LOG_FMT='"%C(dim normal)%h %>(11)%ad %Creset· %<(52,trunc)%s %C(dim)%<(20,trunc)%cn%d"'
GIT_LOG_DATE_FMT='"%a %d %b %Y"'

alias g="git status -s"
alias gl="git log  -n 16 --pretty=format:$GIT_LOG_FMT --date=format:$GIT_LOG_DATE_FMT"

# -----------------------------------------------------------------------------
# Path

export PATH=$HOME/.npm-global/bin:$PATH
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/local/sbin
export PATH=$PATH:/usr/bin
export PATH=$PATH:/bin
export PATH=$PATH:/sbin
export PATH=$PATH:/usr/sbin
export PATH=$PATH:$HOME/.zig
