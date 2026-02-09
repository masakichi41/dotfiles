return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    winopts = {
      height = 0.85,
      width = 0.80,
      preview = {
        layout = 'vertical',
        vertical = 'down:50%',
      },
    },
    keymap = {
      fzf = {
        ['ctrl-q'] = 'select-all+accept', -- 全選択してquickfixへ
      },
    },
  },
  keys = {
    -- ファイル
    { '<leader>sf', '<cmd>FzfLua files<cr>', desc = '[S]earch [F]iles' },
    { '<leader>s.', '<cmd>FzfLua oldfiles<cr>', desc = '[S]earch Recent Files' },
    { '<leader><leader>', '<cmd>FzfLua buffers<cr>', desc = 'Buffers' },

    -- 検索
    { '<leader>sg', '<cmd>FzfLua live_grep<cr>', desc = '[S]earch [G]rep' },
    { '<leader>sw', '<cmd>FzfLua grep_cword<cr>', desc = '[S]earch [W]ord' },
    { '<leader>/', '<cmd>FzfLua lgrep_curbuf<cr>', desc = 'Search in buffer' },
    { '<leader>sr', '<cmd>FzfLua resume<cr>', desc = '[S]earch [R]esume' },

    -- ヘルプ・設定
    { '<leader>sh', '<cmd>FzfLua help_tags<cr>', desc = '[S]earch [H]elp' },
    { '<leader>sk', '<cmd>FzfLua keymaps<cr>', desc = '[S]earch [K]eymaps' },
    {
      '<leader>sn',
      function()
        require('fzf-lua').files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = '[S]earch [N]eovim config',
    },

    -- 診断
    { '<leader>sd', '<cmd>FzfLua diagnostics_document<cr>', desc = '[S]earch [D]iagnostics' },

    -- Git
    { '<leader>gc', '<cmd>FzfLua git_commits<cr>', desc = '[G]it [C]ommits' },
    { '<leader>gs', '<cmd>FzfLua git_status<cr>', desc = '[G]it [S]tatus' },
    { '<leader>gb', '<cmd>FzfLua git_branches<cr>', desc = '[G]it [B]ranches' },

    { '<leader>ss', '<cmd>FzfLua lsp_document_symbols<cr>', desc = 'Document [S]ymbols' },
  },
}
