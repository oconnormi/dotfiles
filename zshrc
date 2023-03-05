# Explicitly configured $PATH variable
#PATH=/home/linuxbrew/.linuxbrew/bin:$HOME/go/bin:$HOME/bin/:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/opt/local/bin:/opt/local/sbin:/usr/X11/bin:/home/mike/.local/lib/aws/bin
#export PATH="${PATH}:${HOME}/.krew/bin"

 # Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
#
# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="blinks"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git sudo kubectl helm)

source $ZSH/oh-my-zsh.sh

if [ -f $HOME/.dircolors/dircolors.ansi-dark ]; then
  if [[ $(uname) = "Darwin" ]]; then
    eval `gdircolors $HOME/.dircolors/dircolors.ansi-dark`
  else
    eval `dircolors $HOME/.dircolors/dircolors.ansi-dark`
  fi
fi

# Put any proprietary or private functions/values in ~/.private, and this will source them
if [ -f $HOME/.private ]; then
  source $HOME/.private
fi

if [ -f $HOME/.profile ]; then
  source $HOME/.profile  # Read Mac .profile, if present.
fi

# Shell Aliases
## Git Aliases
alias gs='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias gco='git checkout '
alias gf='git fetch'
alias got='git '
alias get='git '

# Shell Functions
# qfind - used to quickly find files that contain a string in a directory
qfind () {
  find . -exec grep -l -s $1 {} \;
  return 0
}

# Custom exports
## Set EDITOR to /usr/bin/vim if Vim is installed
if [ -f /usr/bin/vim ]; then
  export EDITOR=/usr/bin/vim
fi

# Unsets
# remove ssh_askpass
unset SSH_ASKPASS
# Use GPG SSH Agent
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
gpg-connect-agent updatestartuptty /bye

export XDG_CONFIG_HOME=$HOME/.config
#export XDG_CACHE_HOME=$HOME/.cache
#export XDG_DATA_HOME=$HOME=/.local/state
export PATH="/home/mike/.local/bin:$PATH"

function decode_kubernetes_secret {
  kubectl get secret $@ -o json | jq '.data | map_values(@base64d)'
}
alias ds="decode_kubernetes_secret"
