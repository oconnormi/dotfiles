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
if [[ -d $HOME/bin ]]; then
  export PATH="$HOME/bin:$PATH"
fi

if [[ -z "$XDG_CONFIG_HOME" ]]; then
  export XDG_CONFIG_HOME=$HOME/.config
fi

if [[ -d $HOME/.zfunc ]]; then
  fpath=( "$HOME/.zfunc" "${fpath[@]}" )
  autoload -Uz compinit
  zstyle ':completion:*' menu select
  # fpath+$HOME/.zfunc
fi

export TERM='xterm-256color'

if [[ -n "$XDG_CONFIG_HOME" ]]; then
  export XDG_CONFIG_HOME=$HOME/.config
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
#         GIT        #
######################
if [[ -x "$(command -v git)" ]]; then
  alias gs='git status '
  alias ga='git add '
  alias gb='git branch '
  alias gc='git commit'
  alias gd='git diff'
  alias gco='git checkout '
  alias gf='git fetch'
  alias got='git '
  alias get='git '
  plugins+=(git)
fi

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
  export VISUAL=lvim
elif [[ -x "$(command -v nvim)" ]]; then
  export EDITOR=nvim
  export VISUAL=nvim
elif [[ -x "$(command -v vim)" ]]; then
  export EDITOR=vim
  export VISUAL=vim
else
  export EDITOR=vi
  export VISUAL=vi
fi

######################
#        RUBY        #
######################

if [[ -d /$HOME/.rvm/bin ]]; then
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
#      GPG AGENT     #
######################

if [[ -x "$(command -v gpg-agent)" ]]; then
  # Activate GPG Agent
  # Add the following to your shell init to set up gpg-agent automatically for every shell
  if [ -f ~/.gnupg/.gpg-agent-info ] && [ -n "$(pgrep gpg-agent)" ]; then
      source ~/.gnupg/.gpg-agent-info
      export GPG_AGENT_INFO
  else
      eval $(gpg-agent --daemon --write-env-file ~/.gnupg/.gpg-agent-info)
  fi
  # Use gpg-agent for ssh auth
  export GPG_TTY=$(tty)
  export SSH_AUTH_SOCK=~/.gnupg/S.gpg-agent.ssh
fi

######################
#       GOLANG       #
######################

if [[ -x "$(command -v go)" ]]; then
  export GOPATH=$HOME/go
  export PATH=$PATH:$GOPATH/bin
  plugins+=(golang)
fi

######################
#      PYTHON        #
######################

# Pyenv
#if [[ -x "$(command -v pyenv)" ]]; then
#  eval "$(pyenv init zsh)"
#  plugins+=(python pyenv poetry)
#fi
#if [[ -d $HOME/.poetry/bin ]]; then
#  export PATH="$HOME/.poetry/bin:$PATH"
#fi

######################
#        JAVA        #
######################

if [[ -d $HOME/.sdkman ]]; then
  export SDKMAN_DIR="$HOME/.sdkman"
  if [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    plugins+=(mvn gradle)
  fi
fi

######################
#     KUBERNETES     #
######################

#if [[ -x "$(command -v kubebuilder)" ]]; then
#  eval "$(kubebuilder completion zsh)"
#fi

if [[ -d $HOME/.rd/bin ]]; then
  ### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
  export PATH="$HOME/.rd/bin:$PATH"
  ### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
fi

alias kns='kubectl config set-context --current --namespace '
alias kctx='kubectl config use-context '
function decode_kubernetes_secret {
  kubectl get secret $@ -o json | jq '.data | map_values(@base64d)'
}
alias ds="decode_kubernetes_secret"

if [[ -d $HOME/.krew/bin ]]; then
  export PATH="${PATH}:${HOME}/.krew/bin"
fi

plugins+=(kubectl helm)


######################
#        RUST        #
######################

if [[ -d $HOME/.cargo/bin ]]; then
  # Rust binaries
  export PATH="$HOME/.cargo/bin:$PATH"
fi

######################
# OH-MY-ZSH SETTINGS #
######################

ZSH=$HOME/.oh-my-zsh

if [[ -n "$TMUX" ]]; then
  ZSH_THEME="arrow"
else
  ZSH_THEME="blinks"
fi

COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins+=(sudo)


if [[ $(uname) = "Darwin" ]]; then
  plugins+=(macos)
fi

source $ZSH/oh-my-zsh.sh

