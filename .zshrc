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

# ls
alias l="ls -lhaG"

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
alias update='brew update && brew upgrade && n latest && npm update -g'


# -----------------------------------------------------------------------------
# rbenv crap
# -----------------------------------------------------------------------------
if hostname | grep Iris >/dev/null; then eval "$(rbenv init -)"; fi


# -----------------------------------------------------------------------------
# Google Cloud SDK
# -----------------------------------------------------------------------------

# The next line updates PATH for the Google Cloud SDK.
if [ -f /Users/ckn/Workspace/dev/google-cloud-sdk/path.zsh.inc ]; then
  source '/Users/ckn/Workspace/dev/google-cloud-sdk/path.zsh.inc'
fi

# The next line enables shell command completion for gcloud.
if [ -f /Users/ckn/Workspace/dev/google-cloud-sdk/completion.zsh.inc ]; then
  source '/Users/ckn/Workspace/dev/google-cloud-sdk/completion.zsh.inc'
fi
