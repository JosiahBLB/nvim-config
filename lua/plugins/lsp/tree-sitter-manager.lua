local M = {}

M.init = function()
  return {
    'romus204/tree-sitter-manager.nvim',
    dependencies = {}, -- tree-sitter CLI must be installed system-wide
    config = function()
      require('tree-sitter-manager').setup {
        ensure_installed = { 'bash', 'lua', 'python', 'c', 'cpp' },
        auto_install = true,
      }
    end,
  }
end

return M
