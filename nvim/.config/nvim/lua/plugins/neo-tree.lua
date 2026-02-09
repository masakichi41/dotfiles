return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  keys = {
    { '<leader>e', '<cmd>Neotree toggle<cr>', desc = 'Toggle Explorer' },
    { '<leader>E', '<cmd>Neotree reveal<cr>', desc = 'Reveal current file' },
  },
  opts = {
    close_if_last_window = true, -- neo-treeだけになったら閉じる
    window = {
      position = 'left',
      width = 30,
      mappings = {
        ['<space>'] = 'none',
        ['l'] = 'open',
        ['h'] = 'close_node',
      },
    },
    filesystem = {
      follow_current_file = { enabled = true },
      hijack_netrw_behavior = 'open_current',
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        never_show = { '.git', '.DS_Store' },
      },
      use_libuv_file_watcher = true,
    },
    default_component_configs = {
      git_status = {
        symbols = {
          added = '+',
          modified = '~',
          deleted = '-',
          renamed = '→',
          untracked = '?',
          ignored = '◌',
          unstaged = '○',
          staged = '●',
          conflict = '!',
        },
      },
    },
  },
}
