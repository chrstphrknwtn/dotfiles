# -----------------------------------------------------------------------------
# zsh setup
# -----------------------------------------------------------------------------

ZSH=$HOME/.oh-my-zsh
ZSH_THEME="ckn"

plugins=(z zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
source ~/Dropbox/AppSupport/Terminal/k/k.sh

# Reload this file
alias reload="source ~/.zshrc"

# -----------------------------------------------------------------------------
# Path
# -----------------------------------------------------------------------------

# Customize to your needs...
export PATH='/usr/local/bin:/usr/local/sbin:$HOME/.rvm/bin:/usr/local/share/npm/bin:/usr/bin:/bin:/sbin:/usr/sbin:$PATH'

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

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
    git status -s --ignored
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

alias gstat=git status -s --ignored

# git verbs
# remind me of useful verbs to prefix gits commits
gv() {
 echo "\033[0;34madd, remove, update, refactor, fix\033[0m";
}


# -----------------------------------------------------------------------------
# Random
# -----------------------------------------------------------------------------

# DB aliases
alias db-mongo="mongod --config /usr/local/etc/mongod.conf"
alias db-redis="redis-server /usr/local/etc/redis.conf"

# Serve some static stuff from CWD fast
serve() {
  if [ "$1" != "" ]
  then
    python -m SimpleHTTPServer $1
  else
    python -m SimpleHTTPServer
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
