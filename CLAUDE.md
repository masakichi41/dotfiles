# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

macOS 向け dotfiles リポジトリ。シンボリックリンクの管理に **GNU Stow** を使用。
zsh、neovim の設定を管理。

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
    ├── aliases.zsh      （air=Go ホットリロード, ccm=ccmanager）
    ├── functions.zsh    （timed: コマンド実行時間の計測）
    ├── history.zsh
    ├── options.zsh
    ├── tools.zsh        （uv, direnv 等の外部ツール初期化）
    ├── ghq.zsh          （mkp: ghq 管理下にプロジェクト作成 + git init）
    ├── fzf.zsh          （Ctrl+R 履歴 / E cdr / G ghq / T ghq親dir / W git worktree）
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
            └── plugins/（1ファイル1プラグイン、lazy.nvim が自動読み込み。
                          LSP/補完/フォーマット/lint/Git/ファイラー等 約20個）
```

新しいツールを追加する場合:
1. トップレベルにディレクトリを作成し、`$HOME` からの相対パスでファイルを配置
2. `install.sh` の stow コマンドにパッケージ名を追加
3. プラグイン等の外部依存があれば `install.sh` にインストール処理を追加

## zsh 設定のアーキテクチャ

- **Oh My Zsh** ベース。`$ZSH_CUSTOM` は `~/.zsh-custom`（stow 経由でリンク）。有効プラグインは `git`, `docker`, `zsh-autosuggestions`、テーマは `my-custom`
- Oh My Zsh が `$ZSH_CUSTOM/*.zsh` を自動 source するため、機能ごとにファイルを分割（読み込み順: plugins → `$ZSH_CUSTOM/*.zsh` → theme）
- **zsh-syntax-highlighting** は `.zshrc` 末尾で手動 source（zle ウィジェット定義より後に読む必要があるため）
- **PATH 戦略**: `.zshenv`（全シェル共通、`LANG=ja_JP.UTF-8` 等も定義）で `proto → Homebrew → ~/.local/bin → … → ~/go/bin` の順に構築。`.zshrc` では `/etc/zprofile` の `path_helper` による並べ替えを打ち消すため proto と Homebrew を再度先頭へ移動（proto 管理のツールバージョンを優先させるため）
- マシン固有の設定は `~/.zshrc.local`（gitignore 対象、テンプレートは `.zshrc.local.example`。Java/Android/PostgreSQL 等の PATH 例を含む）
- zsh プラグイン（`zsh/.zsh-custom/plugins/`）は `install.sh` が clone するため gitignore 対象

## nvim 設定のアーキテクチャ

- **lazy.nvim** でプラグイン管理。初回起動時に自動ブートストラップ
- `lua/plugins/` に 1 ファイル 1 プラグインで配置すれば自動読み込み
- **LSP/開発環境**: `mason.nvim` + `mason-tool-installer` で言語サーバ・ツールを自動インストール。対応言語は Go(gopls)・TS/JS(vtsls, biome, eslint)・Python(pyright, ruff)・Lua(lua_ls)・Ruby(ruby_lsp)・HTML/CSS・Markdown(marksman)・JSON
- **補完** `blink.cmp`(+LuaSnip)、**フォーマット** `conform.nvim`（stylua / biome / prettierd / goimports+gofumpt、保存時に自動実行）、**lint** `nvim-lint`（Go=golangci-lint）
- Go 開発を重点サポート（gopls + goimports/gofumpt/golangci-lint、`autocmds.lua` で Go のタブ幅を 4 に設定）
- マシン固有の設定は `lua/config/local.lua`（gitignore 対象、`pcall(require)` で安全に読み込み）
- macOS 固有の IME 自動切り替え（`macism` コマンド使用、`config/platform.lua`）
- パッケージルートの `CLAUDE.md` は `.stow-local-ignore` により stow 対象外
- 全プラグイン一覧・キーマップ等の詳細は `nvim/CLAUDE.md` を参照

## 注意事項

- `*.local` ファイルは gitignore 対象。マシン固有の秘密情報や PATH を含む
- 新しい zsh カスタムファイルは `.zsh-custom/` 直下に `*.zsh` として配置すれば自動で読み込まれる
- PATH の優先順位を変える場合は `.zshenv` と `.zshrc` の両方を確認する（後者は `path_helper` 対策で再ソートしている）
- `.stow-local-ignore` はデフォルトの ignore リストを**置き換える**ため、Stow デフォルトのパターン（`.git` 等）も含める必要がある
