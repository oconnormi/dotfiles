######################
#       GLOBAL       #
######################

# Define global oh-my-zsh plugins variable early.
# This will be dynamically populated as features and os are detected
plugins=()

# remove ssh_askpass
unset SSH_ASKPASS

# add .local/bin to the path
if [[ -d $HOME/.local/bin ]]; then
  export PATH=$HOME/.local/bin:$PATH
fi

######################
#  DIRCOLORS THEME   #
######################

if [ -f $HOME/.dircolors/dircolors.ansi-dark ]; then
  if [[ $(uname) = "Darwin" ]]; then
    eval `gdircolors $HOME/.dircolors/dircolors.ansi-dark`
  else
    eval `dircolors $HOME/.dircolors/dircolors.ansi-dark`
  fi
fi

######################
#  PRIVATE SETTINGS  #
######################

# Put any proprietary or private functions/values in ~/.private, and this will source them
if [ -f $HOME/.private ]; then
  source $HOME/.private
fi

if [ -f $HOME/.profile ]; then
  source $HOME/.profile  # Read Mac .profile, if present.
fi

######################
#     GIT ALIASES    #
######################

alias gs='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias gco='git checkout '
alias gf='git fetch'
alias got='git '
alias get='git '

######################
#  SHELL FUNCTIONS   #
######################

# qfind - used to quickly find files that contain a string in a directory
qfind () {
  find . -exec grep -l -s $1 {} \;
  return 0
}

######################
#       EDITOR       #
######################

if [[ -x "$(command -v lvim)" ]]; then
  export EDITOR=lvim
elif [[ -x "$(command -v nvim)" ]]; then
  export EDITOR=nvim
elif [[ -x "$(command -v vim)" ]]; then
  export EDITOR=vim
else
  export EDITOR=vi
fi

## Set EDITOR to /usr/bin/vim if Vim is installed
if [ -f /usr/bin/vim ]; then
  export EDITOR=/usr/bin/vim
fi

######################
#        RUBY        #
######################

if [[ -d "/$HOME/.rvm/bin" ]]; then
  export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
  plugins+=(ruby)
fi

######################
#       BREW         #
######################

if [[ $(uname) = "Linux" ]]; then
	if [[ -f ~/.linuxbrew/bin/brew ]]; then
		export PATH="$HOME/.linuxbrew/bin:$PATH"
		export LD_LIBRARY_PATH="$HOME/.linuxbrew/lib:$LD_LIBRARY_PATH"
    export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
    export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
    plugins+=(brew)
	fi
elif [[ $(uname) = "Darwin" ]]; then
	if [[ -f /usr/local/bin/brew ]]; then
    plugins+=(brew)
  fi
fi

######################
# OH-MY-ZSH SETTINGS #
######################

ZSH=$HOME/.oh-my-zsh

ZSH_THEME="blinks"

COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins+=(git sudo node npm)


if [[ $(uname) = "Darwin" ]]; then
  plugins+=(osx)
fi

source $ZSH/oh-my-zsh.sh

