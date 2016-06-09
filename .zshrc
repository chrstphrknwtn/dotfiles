# -----------------------------------------------------------------------------
# zsh setup
# -----------------------------------------------------------------------------

source ~/Dropbox/Apps/Terminal/dotfiles/antigen.zsh

# antigen use oh-my-zsh

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle rupa/z
antigen bundle chrstphrknwtn/pure
antigen bundle supercrabtree/k

antigen apply

# Reload this file
alias reload="source ~/.zshrc"

# -----------------------------------------------------------------------------
# Options
# -----------------------------------------------------------------------------

# Syntax Highlighters
# ZSH_HIGHLIGHT_STYLES[command]=fg=green

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

_Z_DATA=~/.z.data/.z

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
export PATH=$PATH:$HOME/Dropbox/Apps/Terminal/shell-scripts

# -----------------------------------------------------------------------------
# Exports
# -----------------------------------------------------------------------------

export EDITOR=subl

# -----------------------------------------------------------------------------
# z style
# -----------------------------------------------------------------------------

zstyle ':completion:*:*:*:*:*' menu select

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

# Git logs
gl() {
  LINES=20
  if [ $1 ]; then
    LINES=$1
  fi
  git log --decorate --all --pretty="$git_log_defaults" "-$LINES"
}

glb() {
  LINES=20
  if [ $1 ]; then
    LINES=$1
  fi
  git log --decorate --pretty="$git_log_defaults" "-$LINES"
}

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

# Git Logs
alias glg='git log --graph --decorate --all --pretty="$git_log_defaults"'
alias glv='git log --decorate --all --pretty="$git_log_defaults"'

# Git calender
alias gc='git-cal'


# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------

# k
alias k="k -A"
alias l="k --no-vcs"

# Use bash 4 installed by homebrew
alias bash='/usr/local/bin/bash'

# Open CWD in sublime
alias o="subl . > /dev/null"

# DB aliases
alias db-mongo="mongod --config /usr/local/etc/mongod.conf"
alias db-redis="redis-server /usr/local/etc/redis.conf"

# Project Scripts / Task Runners
alias setup="./setup"
alias run="./run"
alias build="./build"
alias deploy="./deploy"
# Even shorter
alias s="./setup"
alias r="./run"
alias b="./build"
alias d="./deploy"

# Flush DNS
alias flushdns="sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder"

# Hidden Files
alias show='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hide='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

# suffix
alias -s git='git clone'


# -----------------------------------------------------------------------------
# Ad-hoc web servers
# -----------------------------------------------------------------------------

# Serve some static stuff from CWD fast with optional port argument
serve() {
  if [ "$1" != "" ]
  then
    python -m SimpleHTTPServer $1
  else
    python -m SimpleHTTPServer
  fi
}

# Serve php from CWD with optional port argument
serve-php() {
  if [ "$1" != "" ]
  then
    php -S localhost:$1
  else
    php -S localhost:8000
  fi
}


# -----------------------------------------------------------------------------
# rbenv crap
# -----------------------------------------------------------------------------
if hostname | grep Iris >/dev/null; then eval "$(rbenv init -)"; fi
