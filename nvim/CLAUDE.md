# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

個人用 Neovim 設定。日本語ローカライズとモダンな開発ツール (LSP, 補完, Git 連携) を統合。

## コマンド

```bash
# Lua ファイルのフォーマット
stylua lua/

# 設定の構文チェック (Neovim 内で実行)
:checkhealth

# プラグイン管理
:Lazy              # プラグイン状態確認
:Lazy sync         # プラグイン同期
:Lazy update       # プラグイン更新

# Mason (LSP/ツール管理)
:Mason             # インストール済みツール確認
```

## アーキテクチャ

### エントリポイント

`init.lua` はリーダーキー設定と config モジュールの require のみ。

### ディレクトリ構成

```
lua/
├── config/           # プラグイン非依存のコア設定
│   ├── options.lua   # vim.opt エディタオプション
│   ├── keymaps.lua   # 基本キーマップ
│   ├── autocmds.lua  # オートコマンド (yank highlight, Go のタブ幅)
│   ├── platform.lua  # OS 依存設定 (macOS IME 切替)
│   └── lazy.lua      # lazy.nvim ブートストラップ
└── plugins/          # プラグイン設定 (1ファイル1プラグイン、自動読み込み)
```

- 新しいプラグインを追加する場合は `lua/plugins/` に新規ファイルを作成
- `require('lazy').setup('plugins')` により自動読み込み
- `lua/config/local.lua` (gitignore) でマシン固有設定を上書き可能

### 主要プラグイン

| カテゴリ | プラグイン |
|---------|-----------|
| パッケージ管理 | lazy.nvim |
| LSP | nvim-lspconfig, mason.nvim, mason-tool-installer |
| 補完 | blink.cmp (+ LuaSnip、super-tab) |
| フォーマッター | conform.nvim (stylua, biome, prettierd, goimports, gofumpt) |
| Linter | nvim-lint (Go: golangci-lint) |
| 構文解析 | nvim-treesitter |
| ファジーファインダー | fzf-lua |
| ファイラー | neo-tree.nvim |
| Git | gitsigns.nvim, lazygit.nvim |
| 編集支援 | mini.nvim (ai/surround/statusline), nvim-autopairs, guess-indent |
| UI | tokyonight (colorscheme), bufferline.nvim, which-key.nvim, todo-comments.nvim |
| その他 | image.nvim (画像表示), vim-wakatime (時間計測), vimdoc-ja (日本語ヘルプ) |

### LSP / フォーマット / Lint

`mason.nvim` + `mason-tool-installer` で言語サーバ・ツールを自動インストール。

- **LSP** (`lsp.lua`): gopls, vtsls, eslint, pyright, ruff, lua_ls, ruby_lsp, html, cssls, marksman, jsonls, biome
- **フォーマッタ** (`conform.lua`): Lua=stylua / JS・TS・JSON=biome→prettierd→prettier / Go=goimports→gofumpt。保存時に自動実行
- **Linter** (`lint.lua`): Go=golangci-lint
- LspAttach 時のキーマップ: `gd`/`gr`/`gi`/`gt`（定義・参照・実装・型定義、fzf-lua 連携）, `<leader>rn` リネーム, `<leader>ca` コードアクション, `<leader>th` inlay hints トグル

### macOS 固有

- IME 自動切り替え機能あり (`macism` コマンド使用、`config/platform.lua`)

## コードスタイル

- フォーマッター: stylua
- カラム幅: 160
- インデント: スペース 2 つ
- クォート: シングルクォート優先
