return {
  {
    'Mofiqul/vscode.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      vim.cmd.colorscheme 'vscode'
      vim.cmd.hi 'Comment gui=none'
    end,
    config = {
      vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = '*',
        callback = function()
          vim.cmd [[highlight CursorLine guibg=#282A36]]
        end,
      }),
    },
  },
  -- other themes:
  -- use `:Telescope colorscheme`.
  {
    'Mofiqul/dracula.nvim',
  },
}
-- vim: ts=2 sts=2 sw=2 et
