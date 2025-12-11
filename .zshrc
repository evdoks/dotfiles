# uncomment to debug shell init 
# set -xeuo pipefail

export TERM="xterm-256color"


# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git pipenv)

# Aliases
alias ll="ls -al"
# alias ohmyzsh="mate ~/.oh-my-zsh"


# check for existence of pyenv and initialize it
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi

# enable auto-activation of virtualenv
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

#
# alias for git used for tracking dot files in .cfg repo
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'


# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
source /Users/sevdokim/Development/OpenPilot/openpilot/tools/openpilot_env.sh
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"


# Visual Studio Code
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# PostgreSQL forwarding aliases
pg_forward_load_aliases() {
    local mappings_file="$HOME/.pg-mappings"

    if [ -f "$mappings_file" ]; then
        while IFS=: read -r alias _ _; do
            if [[ "$alias" != "alias" ]]; then
                alias "pg-$alias"="/Users/sevdokim/Development/Hey/ais-infrastructure/scripts/pg-forward.sh $alias"
            fi
        done < "$mappings_file"
    fi
}

# Load aliases on shell startup
pg_forward_load_aliases
# Add the above block to your shell initialization file (~/.bashrc, ~/.zshrc, etc.)



### Initialize Startship prompt customizer
eval "$(starship init zsh)"


# Automatically switch Node.js version based on .nvmrc
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    nvm use --silent default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
eval "$(direnv hook zsh)"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/sevdokim/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
