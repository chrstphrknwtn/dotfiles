# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="ckn"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git z zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH='/usr/local/bin:/usr/local/sbin:/Users/ckn/.rvm/bin:/usr/local/share/npm/bin:/usr/bin:/bin:/sbin:/usr/sbin:$HOME/.rvm/bin:$PATH'

# PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Temporarily set git config for AJF git server
ajfgit() {
  if [ -f './.git/config' ];
  then
    git config user.name "Christopher Newton" || { return 1; }
    git config user.email cnewton@ajfpartnership.com.au || { return 1; }
    echo "\nSetting local Git Config\nUsername: \033[0;34mChristopher Newton\033[0m\nEmail: \033[0;34m    cnewton@ajfpartnership.com.au\033[0m\n"
  else
     echo "\n\033[0;31mNo git repository found in this directory.\033[0m\n"
     return 1;
  fi
}

# git sync
gs() {
  if [ ! $1 ]
    then
    echo "\n\033[0;31mYou must enter a commit message.\033[0m"
    return 1
  fi

  # debug
  # return 0

  echo "\n\033[0;34mgit add -A\033[0m"
  git add -A || { return 1; }

  echo "\n\033[0;34mgit commit -m \033[0m\033[0;33m$1\033[0m"
  git commit -m $1 || { return 1; }

  echo "\n\033[0;34mgit pull origin master\033[0m"
  git pull origin master || { return 1; }

  echo "\n\033[0;34mgit push origin master\033[0m"
  git push origin master || { return 1; }
}
