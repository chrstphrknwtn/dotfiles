# -----------------------------------------------------------------------------
# zsh setup
# -----------------------------------------------------------------------------

source ~/Dropbox/Apps/Terminal/dotfiles/antigen.zsh

antigen use oh-my-zsh

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle z
antigen bundle chrstphrknwtn/pure
antigen bundle rimraf/k

antigen apply

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
export PATH=$PATH:$HOME/Dropbox/Apps/Terminal/shell-scripts

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

# Git Diff
gd() {
  if [ $1 ]; then
    git diff $1
  else
    git diff
  fi
}

# Git Logs
alias glg='git log --graph --decorate --all --pretty="%C(yellow)%h%C(auto)%d %C(blue)%s %Cgreen%cr %Creset%cn"'
alias glv='git log --decorate --all --pretty="%C(yellow)%h %>(14)%Cgreen%cr%C(auto)%d %C(blue)%s %Creset%cn"'
alias gl='git --no-pager log --decorate --all --pretty="%C(yellow)%h %>(14)%Cgreen%cr%C(auto)%d %C(blue)%s %Creset%cn" -20'


# Toggle ssh identities
# Set default to pix
export SSHIDENT=ckn
ssh-toggle() {
  if [ $SSHIDENT = "pix" ]
  then
    export SSHIDENT=ckn
    echo 'Host github.com\n  HostName github.com\n  User git\n  IdentityFile ~/.ssh/id_rsa\n' > ~/.ssh/config
    echo "\033[38;5;242;mSSH key\033[0m    ~/.ssh/id_rsa"
  else
    export SSHIDENT=pix
    echo 'Host github.com\n  HostName github.com\n  User git\n  IdentityFile ~/.ssh/id_pix\n' > ~/.ssh/config
    echo "\033[38;5;242;mSSH key\033[0m    ~/.ssh/id_pix"
  fi
  echo "\033[38;5;242;mGit whoami\033[0m $(command git-whoami)"
}
alias st='ssh-toggle'


# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------

# k
alias k="k -A"
alias l="k --no-vcs"

# Use bash 4 installed by homebrew
alias bash='/usr/local/Cellar/bash/4.3.30/bin/bash'

# Open CWD in sublime
alias o="subl . > /dev/null"

# DB aliases
alias db-mongo="mongod --config /usr/local/etc/mongod.conf"
alias db-redis="redis-server /usr/local/etc/redis.conf"

# Project Scripts / Task Runners
alias run="./run"
alias build="./build"
alias deploy="./deploy"


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
