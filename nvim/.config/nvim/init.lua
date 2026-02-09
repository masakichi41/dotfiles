-- リーダーキー設定（プラグインより前に設定が必須）
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Nerd Font フラグ
vim.g.have_nerd_font = true

-- コア設定の読み込み
require 'config.options'
require 'config.keymaps'
require 'config.autocmds'
require 'config.platform'

-- マシン固有設定（非追跡、なくても動作する）
pcall(require, 'config.local')

-- プラグインマネージャー
require 'config.lazy'
