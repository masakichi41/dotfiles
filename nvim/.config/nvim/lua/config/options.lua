-- エンコーディング
vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

-- 行番号
vim.o.number = true

-- マウス
vim.o.mouse = 'a'

-- モード表示（ステータスラインに任せる）
vim.o.showmode = false

-- クリップボード同期（UiEnter 後に遅延実行）
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- インデント
vim.o.breakindent = true

-- Undo 履歴を保存
vim.o.undofile = true

-- 検索
vim.o.ignorecase = true
vim.o.smartcase = true

-- サインカラム
vim.o.signcolumn = 'yes'

-- タイミング
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- 分割
vim.o.splitright = true
vim.o.splitbelow = true

-- 空白文字の表示
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- 置換プレビュー
vim.o.inccommand = 'split'

-- カーソルライン
vim.o.cursorline = true

-- スクロールオフ
vim.o.scrolloff = 10

-- 確認ダイアログ
vim.o.confirm = true
