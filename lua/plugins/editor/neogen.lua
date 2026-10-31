local M = {}

M.init = function()
  return {
    {
      'danymat/neogen',
      version = '*',
      config = function()
        require('neogen').setup {}
        vim.keymap.set('n', '<leader>ng', ":lua require('neogen').generate()<CR>", { desc = 'Neogen' })
      end,
    },
  }
end

return M
