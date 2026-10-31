local M = {}

M.init = function()
  return {
    {
      'norcalli/nvim-colorizer.lua',
      config = function()
        require('colorizer').setup()
      end,
    },
  }
end

return M
