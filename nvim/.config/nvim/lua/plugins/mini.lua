return {
  'echasnovski/mini.nvim',
  config = function()
    -- テキストオブジェクト（around/inside 拡張）
    require('mini.ai').setup { n_lines = 500 }

    -- 囲み文字操作（add/delete/replace）
    require('mini.surround').setup {
      mappings = {
        add = 'gsa',
        delete = 'gsd',
        find = 'gsf',
        find_left = 'gsF',
        highlight = 'gsh',
        replace = 'gsr',
        update_n_lines = 'gsn',
      },
    }

    -- ステータスライン
    local statusline = require 'mini.statusline'
    statusline.setup { use_icons = vim.g.have_nerd_font }

    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return '%2l:%-2v'
    end
  end,
}
