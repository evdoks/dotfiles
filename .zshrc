# uncomment to debug shell init 
# set -xeuo pipefail

export TERM="xterm-256color"

# --- PLUGINS ---
# Standard plugins
plugins=(git pipenv)

# --- ALIASES ---
alias ll="ls -al"
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# --- PATH EXPORTS ---
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
# MANAGED BY RANCHER DESKTOP
export PATH="/Users/sevdokim/.rd/bin:$PATH"

# --- PYENV CONFIGURATION ---
# We load this normally (non-lazy) so auto-switching works immediately when you cd
if command -v pyenv 1>/dev/null 2>&1; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    
    # Virtualenv init 
    if which pyenv-virtualenv-init > /dev/null; then 
        eval "$(pyenv virtualenv-init -)"
    fi
fi

# --- FNM (FAST NODE MANAGER) ---
# Replaces NVM. 
# "--use-on-cd" automatically switches node version based on .nvmrc file
# This is nearly instant (written in Rust) vs NVM (slow shell script)
if command -v fnm 1>/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd)"
fi

# --- POSTGRESQL FORWARDING ---
pg_forward_load_aliases() {
    local mappings_file="$HOME/.pg-mappings"
    if [ -s "$mappings_file" ]; then
        while IFS=: read -r alias _ _; do
            if [[ "$alias" != "alias" ]]; then
                alias "pg-$alias"="/Users/sevdokim/Development/Hey/ais-infrastructure/scripts/pg-forward.sh $alias"
            fi
        done < "$mappings_file"
    fi
}
pg_forward_load_aliases

# --- PROMPT ---
eval "$(starship init zsh)"

# --- DIRENV ---
eval "$(direnv hook zsh)"
