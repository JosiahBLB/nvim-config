local M = {}

M.init = function()
  return {
    { -- Add indentation guides even on blank lines
      'lukas-reineke/indent-blankline.nvim',
      -- See `:help ibl`
      dependencies = { 'nvim-treesitter/nvim-treesitter' },
      main = 'ibl',
      opts = {
        indent = { char = '▏' },
        scope = {
          enabled = false,
        },
      },
    },
  }
end

return M
