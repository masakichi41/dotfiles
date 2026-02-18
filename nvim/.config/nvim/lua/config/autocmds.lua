-- ヤンク時のハイライト
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('yank-highlight', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Go: タブ表示幅を4に設定
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  group = vim.api.nvim_create_augroup('go-settings', { clear = true }),
  callback = function()
    vim.opt_local.tabstop = 4
  end,
})
