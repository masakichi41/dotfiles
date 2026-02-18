# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

macOS 向け dotfiles リポジトリ。シンボリックリンクの管理に **GNU Stow** を使用。
zsh、neovim、tmux の設定を管理。tmux + neovim + Claude Code を統合した開発環境を構築している。

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
├── .zshenv             → ~/.zshenv（PATH 設定: proto, Homebrew, Go 等）
├── .zshrc              → ~/.zshrc
├── .zshrc.local.example（stow 対象、テンプレート）
└── .zsh-custom/        → ~/.zsh-custom/
    ├── aliases.zsh
    ├── functions.zsh
    ├── history.zsh
    ├── options.zsh
    ├── tools.zsh       （uv, direnv 等の外部ツール初期化）
    ├── ghq.zsh         （mkp: ghq 管理下にプロジェクト作成）
    ├── fzf.zsh         （Ctrl+R/E/G/T/W のインタラクティブ選択、fzf ベース）
    ├── tmux.zsh        （tm: tmux セッション作成/アタッチ）
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

tmux/                   ← stow パッケージ "tmux"
├── .tmux.conf              → ~/.tmux.conf
├── .tmux.conf.local.example（stow 対象、テンプレート）
├── .local/
│   └── bin/
│       └── tmux-dev        → ~/.local/bin/tmux-dev（開発レイアウトスクリプト）
└── .tmux/
    └── plugins/            （TPM + プラグイン、install.sh が clone、gitignore 対象）
```

新しいツールを追加する場合:
1. トップレベルにディレクトリを作成し、`$HOME` からの相対パスでファイルを配置
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
- 詳細は `nvim/CLAUDE.md` を参照

## tmux 設定のアーキテクチャ

- **TPM (Tmux Plugin Manager)** でプラグイン管理。`install.sh` が clone
- プレフィックスキー: `Ctrl+Space`
- **vim-tmux-navigator** で neovim と tmux 間のペイン移動をシームレスに統合（`Ctrl+hjkl`）
- **tmux-resurrect** でセッション永続化（neovim のセッション復元対応）
- `prefix + D` で開発レイアウト起動（`tmux-dev` スクリプト: nvim 左 50% + claude 右 50%）
- `tm` コマンド（`zsh/.zsh-custom/tmux.zsh`）でカレントディレクトリ名のセッションを作成/アタッチ
- マシン固有の設定は `~/.tmux.conf.local`（gitignore 対象、テンプレートは `.tmux.conf.local.example`）
- tmux プラグイン（`tmux/.tmux/plugins/`）は `install.sh` が clone するため gitignore 対象

## 注意事項

- `*.local` ファイルは gitignore 対象。マシン固有の秘密情報や PATH を含む
- 新しい zsh カスタムファイルは `.zsh-custom/` 直下に `*.zsh` として配置すれば自動で読み込まれる
- `.stow-local-ignore` はデフォルトの ignore リストを**置き換える**ため、Stow デフォルトのパターン（`.git` 等）も含める必要がある
