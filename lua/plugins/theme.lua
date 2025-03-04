return {
  {
    'Mofiqul/vscode.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      vim.cmd.colorscheme 'vscode'
      vim.cmd.hi 'Comment gui=none'
    end,
    opts = {
      terminal_colors = true,
    },
  },
  -- other themes:
  -- use `:Telescope colorscheme`.
  {
    'Mofiqul/dracula.nvim',
  },
}
-- vim: ts=2 sts=2 sw=2 et
