# -----------------------------------------------------------------------------
# zsh setup
# -----------------------------------------------------------------------------

source ~/.dotfiles/antigen.zsh
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle rupa/z
antigen bundle chrstphrknwtn/pure
antigen apply


# -----------------------------------------------------------------------------
# Options
# -----------------------------------------------------------------------------

# History
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

mkdir -p $HOME/.z.data
_Z_DATA=$HOME/.z.data/.z


# -----------------------------------------------------------------------------
# Keyboard Shortcuts
# -----------------------------------------------------------------------------

zle -N up-line-or-beginning-search
zle -N searchup
bindkey "^[[A" searchup

zle -N down-line-or-beginning-search
zle -N searchdown
bindkey "^[[B" searchdown

zle -N fancy-branch
bindkey '^b' fancy-branch


# ------------------------------------------------------------------------------
# ZLE Functions
# ------------------------------------------------------------------------------

searchup() {
  zle up-line-or-beginning-search
  _zsh_highlight
}
searchdown() {
  zle down-line-or-beginning-search
  _zsh_highlight
}


# -----------------------------------------------------------------------------
# Path
# -----------------------------------------------------------------------------

export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/local/sbin
export PATH=$PATH:/usr/bin
export PATH=$PATH:/bin
export PATH=$PATH:/sbin
export PATH=$PATH:/usr/sbin
export PATH=$PATH:$HOME/npm/bin
export PATH=$PATH:/usr/local/heroku/bin
export PATH=$PATH:$HOME/.bin


# -----------------------------------------------------------------------------
# Exports
# -----------------------------------------------------------------------------

export EDITOR=subl


# -----------------------------------------------------------------------------
# z style
# -----------------------------------------------------------------------------

zstyle ':completion:*:*:*:*:*' menu select


# -----------------------------------------------------------------------------
# less (man pages) color / style
# -----------------------------------------------------------------------------

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
# Git
# -----------------------------------------------------------------------------

export GIT_MERGE_AUTOEDIT=no

git_log_defaults="%C(yellow)%h %>(14)%Cgreen%cr %C(blue)%<(55,trunc)%s %Creset%<(20,trunc)%cn%C(auto)%d"

# No arguments: `git status`
# With arguments: acts like `git`
g() {
  if [[ $# > 0 ]]; then
    git $@
  else
    git status -s
  fi
}

# Git Diff
gd() {
  if [ $1 ]; then
    git diff $1
  else
    git diff
  fi
}

# Last 20 commits
gl() {
  LINES=20
  if [ $1 ]; then
    LINES=$1
  fi
  git log --decorate --all --pretty="$git_log_defaults" "-$LINES"
}

# last 20 commits in current branch
glb() {
  LINES=20
  if [ $1 ]; then
    LINES=$1
  fi
  git log --decorate --pretty="$git_log_defaults" "-$LINES"
}

# All the logs
alias glg='git log --graph --decorate --all --pretty="$git_log_defaults"'
alias glv='git log --decorate --all --pretty="$git_log_defaults"'

# Open current repo in browsers
gh() {
  giturl=$(git config --get remote.origin.url)
  if [ $giturl ]; then
    giturl=${giturl/git\@github\.com\:/https://github.com/}
    giturl=${giturl/\.git/\/tree/}
    branch="$(git symbolic-ref HEAD 2>/dev/null)" ||
    branch="(unnamed branch)"     # detached HEAD
    branch=${branch##refs/heads/}
    giturl=$giturl$branch
    echo $giturl
    open $giturl
  else
    echo "Not a git repository or no remote set."
  fi
}

# ctrl-b to switch branch
fancy-branch() {
  local tags localbranches remotebranches target
  tags=$(
  git tag | awk '{print "\x1b[33;1mtag\x1b[m\t" $1}') || return
  localbranches=$(
  git for-each-ref --sort=-committerdate refs/heads/ |
  sed 's|.*refs/heads/||' |
  awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  remotebranches=$(
  git branch --remote | grep -v HEAD             |
  sed "s/.* //"       | sed "s#remotes/[^/]*/##" |
  sort -u             | awk '{print "\x1b[31;1mremote\x1b[m\t" $1}') || return
  target=$(
  (echo "$localbranches"; echo "$tags"; echo "$remotebranches";) |
  fzf --no-hscroll --ansi +m -d "\t" -n 2) || return
  if [[ -z "$BUFFER" ]]; then
    if [[ $(echo "$target" | awk '{print $1}') == 'remote' ]]; then
      target=$(echo "$target" | awk '{print $2}' | sed 's|.*/||')
      git checkout "$target"
      zle accept-line
    else
      git checkout $(echo "$target" | awk '{print $2}')
      zle accept-line
    fi
  else
    res=$(echo "$target" | awk '{print $2}')
    LBUFFER="$(echo "$LBUFFER" | xargs) ${res}"
    zle redisplay
  fi
}


# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------

# Open this file
alias zshrc='o $HOME/.zshrc'

# ls
alias ll="ls -laG"

# Open CWD in sublime
alias o="subl . > /dev/null"

# Flush DNS
alias flushdns="sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder"

# Hidden Files
alias show='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hide='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

# suffix
alias -s git='git clone'

# update
alias update='softwareupdate --install --all && brew update && brew upgrade && brew cleanup && n latest && npm update -g'

# z [enter]
unalias z 2> /dev/null
z() {
  if [[ -z "$*" ]]; then
    cd "$(_z -l 2>&1 | fzf +s --tac | sed 's/^[0-9,.]* *//')"
  else
    _z "$@"
  fi
}

# prefer homebrew vim
alias vi='/usr/local/bin/vim'
alias vim='vi'


# -----------------------------------------------------------------------------
# Google Cloud SDK
# -----------------------------------------------------------------------------

# The next line updates PATH for the Google Cloud SDK.
if [ -f $HOME/.cli/google-cloud-sdk/path.zsh.inc ]; then
  source $HOME/.cli/google-cloud-sdk/path.zsh.inc
fi

# The next line enables shell command completion for gcloud.
if [ -f $HOME/.cli/google-cloud-sdk/completion.zsh.inc ]; then
  source $HOME/.cli/google-cloud-sdk/completion.zsh.inc
fi


cfmt() {
  if [[ $# -ne 1 ]]; then
    echo "Usage: cfmt <file>"
  else
    astyle \
      --style=1tbs \
      --lineend=linux \
      --preserve-date \
      --pad-header \
      --indent=tab \
      --indent-switches \
      --align-pointer=name \
      --align-reference=name \
      --pad-oper \
      --suffix=none \
      $1
  fi
}


ccw() {
  type fswatch >/dev/null 2>&1 || { echo >&2 "fswatch required: brew install fswatch."; return 0; }
  if [[ $# -ne 2 ]]; then
    echo "Usage: ccm <input.c> <out>"
  else
    command fswatch $1 | (while read; do echo ""; cc $1 -o $2 && $2; done)
  fi
}
