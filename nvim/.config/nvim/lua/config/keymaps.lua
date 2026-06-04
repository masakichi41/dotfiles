local map = vim.keymap.set

-- 検索ハイライト解除
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- 診断リスト
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- ターミナルモード終了
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- 十字キー無効化（hjkl に慣れるための矯正）
local nop = '<Nop>'
for _, key in ipairs({ '<Up>', '<Down>', '<Left>', '<Right>' }) do
  map({ 'n', 'v' }, key, nop, { desc = 'Use hjkl instead' })
end

-- jj で Normal モードに戻る
map('i', 'jj', '<Esc>', { desc = 'Exit insert mode' })

-- ターミナルトグル
map('n', '<leader>ot', function()
  -- neo-tree ウィンドウ上にいる場合は隣に移動
  if vim.bo.filetype == 'neo-tree' then
    vim.cmd 'wincmd l'
    if vim.bo.filetype == 'neo-tree' then
      vim.cmd 'vsplit'
    end
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == 'terminal' then
      vim.api.nvim_set_current_buf(buf)
      return
    end
  end
  vim.cmd 'terminal'
end, { desc = '[O]pen [T]erminal' })
