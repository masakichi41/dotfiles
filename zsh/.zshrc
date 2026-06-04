# Path to Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="my-custom"

# Plugins (custom plugins are in $ZSH_CUSTOM/plugins/)
plugins=(
  git
  docker
  zsh-autosuggestions
)

# Custom directory
export ZSH_CUSTOM="$HOME/.zsh-custom"

# Reorder proto and Homebrew to the front (override /etc/zprofile's path_helper)
# proto must come before Homebrew so proto-managed tool versions take precedence
path=($PROTO_HOME/shims $PROTO_HOME/bin /opt/homebrew/bin /opt/homebrew/sbin $path)

# Initialize Oh My Zsh
# Auto-sources: plugins → $ZSH_CUSTOM/*.zsh → theme
source "$ZSH/oh-my-zsh.sh"

# zsh-syntax-highlighting: must be sourced AFTER all zle widget definitions
# (fzf.zsh etc. define widgets via OMZ custom auto-source above)
local _zsh_sh="$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[[ -f "$_zsh_sh" ]] && source "$_zsh_sh"
unset _zsh_sh

# Machine-specific settings
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
