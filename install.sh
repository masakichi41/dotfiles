#!/bin/bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
BACKUP_SUFFIX=".backup.$(date +%Y%m%d%H%M%S)"

# --- Homebrew packages (stow, fzf, fd, ripgrep, ghq, neovim) ---
echo "==> Installing missing Homebrew packages..."
brew bundle --file="$DOTFILES/Brewfile"

# --- Zsh plugins (latest, with update support) ---
echo "==> Installing/updating zsh plugins..."
ZSH_PLUGINS="$DOTFILES/zsh/.zsh-custom/plugins"
mkdir -p "$ZSH_PLUGINS"

install_plugin() {
  local repo="$1"
  local name="$(basename "$repo" .git)"
  local dest="$ZSH_PLUGINS/$name"
  if [[ -d "$dest/.git" ]]; then
    echo "  $name: updating..."
    git -C "$dest" pull --ff-only
  elif [[ -d "$dest" ]]; then
    echo "  $name: exists but not a git repo, backing up and re-cloning..."
    mv "$dest" "$dest$BACKUP_SUFFIX"
    git clone --depth 1 "$repo" "$dest"
  else
    echo "  $name: cloning..."
    git clone --depth 1 "$repo" "$dest"
  fi
}

install_plugin https://github.com/zsh-users/zsh-autosuggestions.git
install_plugin https://github.com/zsh-users/zsh-syntax-highlighting.git

# --- TPM (Tmux Plugin Manager) ---
echo "==> Installing/updating TPM..."
TPM_DIR="$DOTFILES/tmux/.tmux/plugins/tpm"
mkdir -p "$(dirname "$TPM_DIR")"
if [[ -d "$TPM_DIR/.git" ]]; then
  echo "  tpm: updating..."
  git -C "$TPM_DIR" pull --ff-only
elif [[ -d "$TPM_DIR" ]]; then
  echo "  tpm: exists but not a git repo, backing up and re-cloning..."
  mv "$TPM_DIR" "$TPM_DIR$BACKUP_SUFFIX"
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  echo "  tpm: cloning..."
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# --- Oh My Zsh ---
echo "==> Installing/updating Oh My Zsh..."
if [[ -d "$HOME/.oh-my-zsh/.git" ]]; then
  git -C "$HOME/.oh-my-zsh" pull --ff-only
elif [[ -d "$HOME/.oh-my-zsh" ]]; then
  echo "  ~/.oh-my-zsh exists but not a git repo, backing up and re-cloning..."
  mv "$HOME/.oh-my-zsh" "$HOME/.oh-my-zsh$BACKUP_SUFFIX"
  git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
else
  git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
fi

# --- Local config ---
echo "==> Setting up local config..."
if [[ -f "$HOME/.zshrc.local" ]]; then
  echo "  .zshrc.local: already exists"
else
  echo "  .zshrc.local: created from template"
  cp "$DOTFILES/zsh/.zshrc.local.example" "$HOME/.zshrc.local"
fi
if [[ -f "$HOME/.tmux.conf.local" ]]; then
  echo "  .tmux.conf.local: already exists"
else
  echo "  .tmux.conf.local: created from template"
  cp "$DOTFILES/tmux/.tmux.conf.local.example" "$HOME/.tmux.conf.local"
fi

# --- Stow ---
echo "==> Stowing dotfiles..."
stow -d "$DOTFILES" -t "$HOME" --restow zsh nvim tmux

echo ""
echo "Done! Restart your shell or run: exec zsh"
