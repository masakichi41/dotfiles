return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = '',
      desc = 'Format buffer',
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
      typescript = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
      javascriptreact = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
      typescriptreact = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
      json = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
    formatters = {
      biome = {
        condition = function(self, ctx)
          return vim.fs.find({ 'biome.json', 'biome.jsonc' }, {
            path = ctx.filename,
            upward = true,
          })[1] ~= nil
        end,
      },
      prettierd = {
        condition = function(self, ctx)
          return vim.fs.find({
            '.prettierrc',
            '.prettierrc.json',
            '.prettierrc.js',
            'prettier.config.js',
            'prettier.config.mjs',
          }, { path = ctx.filename, upward = true })[1] ~= nil
        end,
      },
      prettier = {
        condition = function(self, ctx)
          return vim.fs.find({
            '.prettierrc',
            '.prettierrc.json',
            '.prettierrc.js',
            'prettier.config.js',
            'prettier.config.mjs',
          }, { path = ctx.filename, upward = true })[1] ~= nil
        end,
      },
    },
  },
}
