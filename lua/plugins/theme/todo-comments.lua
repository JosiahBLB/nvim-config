-- Highlight todo, notes, etc in comments
local M = {}

M.init = function()
  return {
    { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  }
end

return M
-- vim: ts=2 sts=2 sw=2 et
