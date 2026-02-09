return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  event = 'VeryLazy',
  opts = {
    options = {
      mode = 'buffers',
      separator_style = 'thin',
      show_buffer_close_icons = false,
      show_close_icon = false,
      diagnostics = 'nvim_lsp',
      offsets = {
        {
          filetype = 'neo-tree',
          text = 'Explorer',
          highlight = 'Directory',
          separator = true,
        },
      },
    },
  },
  keys = {
    { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev buffer' },
    { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next buffer' },
    { '<leader>bp', '<cmd>BufferLinePick<cr>', desc = 'Pick buffer' },
    { '<leader>bc', '<cmd>BufferLinePickClose<cr>', desc = 'Pick close' },
    {
      '<leader>x',
      function()
        local buf = vim.api.nvim_get_current_buf()
        local buftype = vim.bo[buf].buftype
        if buftype == '' then
          vim.cmd 'bdelete'
        end
      end,
      desc = 'Close buffer',
    },
  },
}
