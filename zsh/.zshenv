# PATH 重複排除（すべてのシェルで有効）
typeset -U path PATH

# Language
export LANG=ja_JP.UTF-8

# Homebrew
export HOMEBREW_NO_AUTO_UPDATE=1

# Go
export GOPATH="$HOME/go"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"

# proto
export PROTO_HOME="$HOME/.proto"

# Base PATH (available to all shell types including non-interactive)
path=(
  /opt/homebrew/bin
  $HOME/.local/bin
  $PROTO_HOME/shims
  $PROTO_HOME/bin
  $PNPM_HOME
  $HOME/.nodebrew/current/bin
  /opt/homebrew/opt/openjdk/bin
  $path
  $GOPATH/bin
)
