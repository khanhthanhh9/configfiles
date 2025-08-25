# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# If you come from bash you might have to change your $PATH.
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH=~/usr/bin:/bin:/usr/sbin:/sbin:$PATH
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="half-life" # set by `omz`
export TERM="xterm-256color"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh
source $HOME/.dotfiles/zsh/.nvim-switch.sh
# User configuration
bindkey -s ^f "~/airutils/tmux-sessionizer\n"
bindkey -s ^s "~/airutils/tmux-snip\n"
bindkey -s ^t "~/airutils/tmux-cht.sh\n"
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias k='kubectl'

# # Enable kubectl autocompletion
# source <(kubectl completion zsh)
# # Optional: load completion for alias 'k'
# compdef __start_kubectl k

# bun completions
# [ -s "/home/aircollides/.bun/_bun" ] && source "/home/aircollides/.bun/_bun"

# bun
# export BUN_INSTALL="$HOME/.bun"
# export PATH="$BUN_INSTALL/bin:$PATH"

# bun
# export BUN_INSTALL="$HOME/.bun"
# export PATH="$BUN_INSTALL/bin:$PATH"
# export PATH=$PATH:/usr/local/go/bin

# bindkey ^R history-incremental-search-backward 
# bindkey ^S history-incremental-search-forward
# bindkey ^F ~/.dotfiles/airutils/tmux-sessionizer
tmux_sessionizer() {
  ~/airutils/tmux-sessionizer
}

cheat_sheet() {
  ~/airutils/tmux-cht.sh
}

tmux_snip() {
  ~/airutils/tmux-snip
}

set_brightness() {
  local val=$1
  if ! [[ "$val" =~ ^[0-9]+$ ]]; then
    echo "Usage: set_brightness <0–100>"
    return 1
  fi
  pkexec ddcutil setvcp 10 "$val"
}


generate_password() {
  echo "Generate password, please enter the name of the file "

  # Check for filename argument
  if [ -z "$1" ]; then
    echo "Error: No filename provided"
    return 1
  fi

  local filename="$1"

  # Generate password
  # if ! head /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 100 | tee "$filename" > /dev/null; then
  if ! head /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 100 | tee "$filename"; then
    echo "Error: Failed to generate password"
    return 1
  fi
  echo

  echo "Encrypting the message..."
  if ! ansible-vault encrypt "$filename"; then
    echo "Encryption failed. Exiting."
    return 1
  fi

  echo "Moving file into GitHub repository..."
  if ! mv -fv "$filename" ~/personal/secretpass/; then
    echo "Failed to move file"
    return 1
  fi

  echo "Cleaning up and pushing to repo..."
  (
    cd ~/personal/secretpass || exit 1
    git add .
    git commit -m "add $filename to password file"
    git push
  ) || {
    echo "Git operation failed"
    return 1
  }

  echo "Done"
}
alias genpass="generate_password $1"

## Encrypt, put into repository, push to git

cfvim() {
  cd "$HOME/.dotfiles/nvim/.config" || return
  nvim .
}

blender() {
  /home/aircollides/blender-4.4.3/blender&
}
ssh_aws_master() {
  ssh -i "~/.ssh/masternode.pem" ubuntu@ec2-13-211-145-149.ap-southeast-2.compute.amazonaws.com
}

ssh_aws_worker1() {

  ssh -i "~/.ssh/masternode.pem" ubuntu@ec2-13-239-132-49.ap-southeast-2.compute.amazonaws.com
}

ssh_aws_worker2() {

  ssh -i "~/.ssh/masternode.pem" ubuntu@ec2-3-106-217-33.ap-southeast-2.compute.amazonaws.com
}
# vim dawg
bindkey -v

zle -N tmux_sessionizer
zle -N cheat_sheet
zle -N tmux_snip

bindkey '^F' tmux_sessionizer
bindkey '^T' cheat_sheet
bindkey '^S' tmux_snip

## Starting tmux automatically
tmux
xmodmap ~/.dotfiles/xmod/hjkl

# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/home/aircollides/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

export PATH="/opt/nvim-linux64/bin:$PATH"
export XDG_CONFIG_HOME="$HOME/.dotfiles/nvim/.config" nvim

