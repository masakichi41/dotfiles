# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

macOS 向け dotfiles リポジトリ。シンボリックリンクの管理に **GNU Stow** を使用。
現在 zsh と neovim の設定が実装済み。tmux の設定を追加予定。

## コマンド

```bash
# 初回セットアップ / 更新（プラグインインストール + Oh My Zsh + stow）
./install.sh

# 特定パッケージのみ stow（例: zsh）
stow -d . -t "$HOME" --restow zsh

# stow の解除
stow -d . -t "$HOME" -D zsh
```

## ディレクトリ構造と Stow の規約

各トップレベルディレクトリが Stow の「パッケージ」に対応する。ディレクトリ内のファイル構造がそのまま `$HOME` 配下にシンボリックリンクされる。

```
zsh/                    ← stow パッケージ "zsh"
├── .zshrc              → ~/.zshrc
├── .zshrc.local.example（stow 対象、テンプレート）
└── .zsh-custom/        → ~/.zsh-custom/
    ├── aliases.zsh
    ├── functions.zsh
    ├── history.zsh
    ├── options.zsh
    ├── tools.zsh       （uv, direnv 等の外部ツール初期化）
    ├── ghq.zsh         （mkp: ghq 管理下にプロジェクト作成）
    ├── peco.zsh        （Ctrl+R/E/G/T/W のインタラクティブ選択）
    └── themes/my-custom.zsh-theme

nvim/                   ← stow パッケージ "nvim"
├── CLAUDE.md           （Claude Code ガイダンス、stow 対象外）
├── .stow-local-ignore  （CLAUDE.md 等を stow 対象外にする）
└── .config/
    └── nvim/           → ~/.config/nvim/
        ├── init.lua
        ├── .stylua.toml
        ├── lazy-lock.json
        └── lua/
            ├── config/ （options, keymaps, autocmds, platform, lazy）
            └── plugins/（1ファイル1プラグイン、lazy.nvim が自動読み込み）
```

新しいツール（tmux 等）を追加する場合:
1. トップレベルに `tmux/` 等のディレクトリを作成し、`$HOME` からの相対パスでファイルを配置
2. `install.sh` の stow コマンドにパッケージ名を追加
3. プラグイン等の外部依存があれば `install.sh` にインストール処理を追加

## zsh 設定のアーキテクチャ

- **Oh My Zsh** ベース。`$ZSH_CUSTOM` は `~/.zsh-custom`（stow 経由でリンク）
- Oh My Zsh が `$ZSH_CUSTOM/*.zsh` を自動 source するため、機能ごとにファイルを分割
- **zsh-syntax-highlighting** は `.zshrc` 末尾で手動 source（zle ウィジェット定義より後に読む必要があるため）
- マシン固有の設定は `~/.zshrc.local`（gitignore 対象、テンプレートは `.zshrc.local.example`）
- zsh プラグイン（`zsh/.zsh-custom/plugins/`）は `install.sh` が clone するため gitignore 対象

## nvim 設定のアーキテクチャ

- **lazy.nvim** でプラグイン管理。初回起動時に自動ブートストラップ
- `lua/plugins/` に 1 ファイル 1 プラグインで配置すれば自動読み込み
- マシン固有の設定は `lua/config/local.lua`（gitignore 対象、`pcall(require)` で安全に読み込み）
- macOS 固有の IME 自動切り替え（`macism` コマンド使用、`config/platform.lua`）
- パッケージルートの `CLAUDE.md` は `.stow-local-ignore` により stow 対象外

## 注意事項

- `*.local` ファイルは gitignore 対象。マシン固有の秘密情報や PATH を含む
- 新しい zsh カスタムファイルは `.zsh-custom/` 直下に `*.zsh` として配置すれば自動で読み込まれる
- `.stow-local-ignore` はデフォルトの ignore リストを**置き換える**ため、Stow デフォルトのパターン（`.git` 等）も含める必要がある
