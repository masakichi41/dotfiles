# dotfiles

macOS 向け dotfiles。GNU Stow でシンボリックリンクを管理し、zsh / neovim の設定をまとめている。

## セットアップ

### 前提

以下は事前にインストール済みであること。

- [Homebrew](https://brew.sh/)
- git

### 1. Homebrew パッケージ

`stow` / `fzf` / `fd` / `ripgrep` / `ghq` / `neovim` は `Brewfile` で管理している。`install.sh` が内部で `brew bundle` を実行し、不足分だけインストールする。単体で確認したい場合は以下でも可。

```bash
brew bundle check   # 不足パッケージの確認のみ
brew bundle         # 不足分をインストール
```

### 2. インストール

```bash
git clone <this-repo> ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

zsh プラグイン・Oh My Zsh の clone、`~/.zshrc.local` の初期生成、Stow によるリンクまで行う。

### 3. その他（任意）

Brewfile には含めていないため、必要に応じて個別に用意する。

- **Nerd Font**: neovim のアイコン表示（neo-tree, bufferline 等）に使う。好みのフォントを別途インストール
- **proto**: `.zshenv` が `$PROTO_HOME/shims` を優先 PATH に置く前提になっている。Homebrew 配布ではないため proto 公式のインストール手順に従う

## ディレクトリ構成・アーキテクチャ

詳細は [CLAUDE.md](./CLAUDE.md) を参照。
