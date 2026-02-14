return {
  'christoomey/vim-tmux-navigator',
  keys = {
    { '<C-h>', '<cmd>TmuxNavigateLeft<cr>', desc = 'Move to left pane/window' },
    { '<C-j>', '<cmd>TmuxNavigateDown<cr>', desc = 'Move to lower pane/window' },
    { '<C-k>', '<cmd>TmuxNavigateUp<cr>', desc = 'Move to upper pane/window' },
    { '<C-l>', '<cmd>TmuxNavigateRight<cr>', desc = 'Move to right pane/window' },
  },
}
