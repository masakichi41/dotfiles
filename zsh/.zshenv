# PATH 重複排除（すべてのシェルで有効）
typeset -U path PATH

# Language
export LANG=ja_JP.UTF-8

# Homebrew
export HOMEBREW_NO_ENV_HINTS=1

# proto
export PROTO_HOME="$HOME/.proto"

# Base PATH (available to all shell types including non-interactive)
path=(
  $PROTO_HOME/shims
  $PROTO_HOME/bin
  /opt/homebrew/bin
  /opt/homebrew/sbin
  $HOME/.local/bin
  /opt/homebrew/opt/openjdk/bin
  $path
  $HOME/go/bin
)
