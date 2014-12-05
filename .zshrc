# -----------------------------------------------------------------------------
# zsh setup
# -----------------------------------------------------------------------------

ZSH=$HOME/.oh-my-zsh
ZSH_THEME="ckn"

plugins=(z zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
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

export GOPATH=$HOME/Workspace/Dev/go
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
compdef g=git

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

# git log verbose
alias glg='git log --graph --decorate --all --pretty="%C(yellow)%h%C(auto)%d %C(blue)%s %Cgreen%cr %Creset%cn"'
alias glv='git log --decorate --all --pretty="%C(yellow)%h %>(14)%Cgreen%cr%C(auto)%d %C(blue)%s %Creset%cn"'
alias gl='git --no-pager log --decorate --all --pretty="%C(yellow)%h %>(14)%Cgreen%cr%C(auto)%d %C(blue)%s %Creset%cn" -20'


# -----------------------------------------------------------------------------
# Random
# -----------------------------------------------------------------------------

# Open CWD in sublime
alias o="subl ."

# DB aliases
alias db-mongo="mongod --config /usr/local/etc/mongod.conf"
alias db-redis="redis-server /usr/local/etc/redis.conf"

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

# Quickly make a directory with yeoman generated app to play with
play() {
  if [ $1 ]
    then
    if [ $2 ]
      then
      NAME=$1-$2
    else
      NAME=$1-$[($RANDOM % 13843) + 1]
    fi
    cd ~/Workspace/dev && mkdir $NAME && cd $_
    yo $1
    subl .
  else
    cd ~/Workspace/dev && mkdir yeah-$[($RANDOM % 13843) + 1] && cd $_
  fi
}

colortest() {
  echo -en "\n   +  "
  for i in {0..35}; do
    printf "%2b " $i
  done
  printf "\n\n %3b  " 0
  for i in {0..15}; do
    echo -en "\033[48;5;${i}m  \033[m "
  done
  #for i in 16 52 88 124 160 196 232; do
  for i in {0..6}; do
    let "i = i*36 +16"
    printf "\n\n %3b  " $i
    for j in {0..35}; do
      let "val = i+j"
      echo -en "\033[48;5;${val}m  \033[m "
    done
  done
  echo -e "\n"
}

# Update everything
alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm update npm -g;'
