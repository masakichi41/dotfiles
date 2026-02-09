-- IME 自動切り替え（macOS）
if vim.fn.has 'mac' == 1 and vim.fn.executable 'macism' == 1 then
  local ime_group = vim.api.nvim_create_augroup('ime-control', { clear = true })

  vim.api.nvim_create_autocmd({
    'InsertLeave',
    'CmdlineLeave',
    'FocusGained',
    'VimEnter',
  }, {
    group = ime_group,
    pattern = '*',
    callback = function()
      vim.fn.jobstart({ 'macism', 'com.apple.keylayout.ABC' }, { detach = true })
    end,
  })
end
