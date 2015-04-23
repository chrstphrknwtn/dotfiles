# -----------------------------------------------------------------------------
# zsh setup
# -----------------------------------------------------------------------------

source ~/Dropbox/Apps/Terminal/dotfiles/antigen.zsh

antigen use oh-my-zsh

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle z
antigen bundle chrstphrknwtn/pure

antigen apply

# source $ZSH/oh-my-zsh.sh
source ~/Dropbox/Apps/Terminal/k/k.sh

# Reload this file
alias reload="source ~/.zshrc"

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
export PATH=$PATH:/usr/local/go/bin

# Go
export GOBIN=$HOME/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# -----------------------------------------------------------------------------
# Git
# -----------------------------------------------------------------------------

export GIT_MERGE_AUTOEDIT=no

# No arguments: `git status`
# With arguments: acts like `git`
g() {
  if [[ $# > 0 ]]; then
    git $@
  else
    git status -s
  fi
}
# Complete g like git
# compdef g=git

# git sync
gs() {
  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD);

  if [ ! $1 ]
    then
    echo "\n\033[0;31mYou must enter a commit message.\033[0m"
    return 1
  fi

  echo "\n\033[0;34mgit add -A\033[0m"
  git add -A || { return 1; }

  echo "\n\033[0;34mgit commit -m \033[0m\033[0;33m$1\033[0m"
  git commit -m $1 || { return 1; }

  echo "\n\033[0;34mgit pull origin $CURRENT_BRANCH\033[0m"
  git pull origin $CURRENT_BRANCH || { return 1; }

  echo "\n\033[0;34mgit push origin $CURRENT_BRANCH\033[0m"
  git push origin $CURRENT_BRANCH || { return 1; }
}

# git verbs
# remind me of useful verbs to prefix gits commits
gv() {
 echo "\033[0;34madd, remove, update, refactor, fix\033[0m";
}

# Git diff
gd() {
  if [ $1 ]; then
    git diff $1
  else
    git diff
  fi
}

# Pull request
# Usage: $ pr ['message' -optional] [to branch -optional] [from branch -optional]
pr() {
  if [ $1 ]; then
    MESSAGE=$1
  else
    MESSAGE=$(git log -1 --pretty=%s)
  fi
  echo $MESSAGE
  if [ $2 ]; then
    TO_BRANCH=$2
  else
    TO_BRANCH=dev;
  fi
  if [ $3 ]; then
    FROM_BRANCH=$3;
  else
    FROM_BRANCH=$(git rev-parse --abbrev-ref HEAD);
  fi
  hub pull-request -m $MESSAGE -b $TO_BRANCH -h $FROM_BRANCH | pbcopy
}

# Toggle ssh identities
# Set default to pic
export SSHIDENT=pix
ssh-toggle() {
  if [ $SSHIDENT = "pix" ]
  then
    export SSHIDENT=me
    echo 'Host github.com\n  HostName github.com\n  User git\n  IdentityFile ~/.ssh/id_rsa\n' > ~/.ssh/config
    echo "\033[38;5;242;mUsing ssh key\033[0m ~/.ssh/id_rsa"
  else
    export SSHIDENT=pix
    echo 'Host github.com\n  HostName github.com\n  User git\n  IdentityFile ~/.ssh/id_pix\n' > ~/.ssh/config
    echo "\033[38;5;242;mUsing ssh key\033[0m ~/.ssh/id_pix"
  fi
}
alias st='ssh-toggle'

# git log verbose
alias glg='git log --graph --decorate --all --pretty="%C(yellow)%h%C(auto)%d %C(blue)%s %Cgreen%cr %Creset%cn"'
alias glv='git log --decorate --all --pretty="%C(yellow)%h %>(14)%Cgreen%cr%C(auto)%d %C(blue)%s %Creset%cn"'
alias gl='git --no-pager log --decorate --all --pretty="%C(yellow)%h %>(14)%Cgreen%cr%C(auto)%d %C(blue)%s %Creset%cn" -20'


# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------

# k
alias k="k -a"
alias l="k --no-vcs"

# Use bash 4 installed by homebrew
alias bash='/usr/local/Cellar/bash/4.3.30/bin/bash'

# Open CWD in sublime
alias o="subl ."

# DB aliases
alias db-mongo="mongod --config /usr/local/etc/mongod.conf"
alias db-redis="redis-server /usr/local/etc/redis.conf"

# Deploy script alias
alias deploy="./deploy.sh"

# Node Webkit on CWD
alias nw="/Applications/node-webkit.app/Contents/MacOS/node-webkit ."

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
