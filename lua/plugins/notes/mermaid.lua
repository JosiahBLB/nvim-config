local M = {}

M.init = function()
  return {
    'kevalin/mermaid.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('mermaid').setup()

      -- Install the Tree-sitter parser:
      -- :TSInstall mermaid
    end,
  }
end

return M
