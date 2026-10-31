local M = {}

M.init = function()
  return {
    {
      'xiyaowong/transparent.nvim',
      opts = {
        exclude_groups = {
          'CursorLine',
        }, -- Groups not to clear
      },
      config = function ()
        require('transparent').clear_prefix('NeoTree')
      end
    },
  }
end

return M
