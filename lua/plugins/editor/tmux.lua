local M = {}

M.init = function()
  return {
    {
      'aserowy/tmux.nvim',
      event = 'VeryLazy',
      config = function()
        local tmux = require 'tmux'
        tmux.setup {
          copy_sync = {
            enable = false,
          },
        }

        -- inside herdr, vim-herdr-navigation takes over <C-hjkl> from tmux.nvim
        if vim.env.HERDR_PANE_ID then
          local herdr_nav = vim.fn.glob('~/.config/herdr/plugins/github-installations/vim-herdr-navigation-*/*/checkout/editor/nvim.lua', false, true)[1]
          if herdr_nav then
            dofile(herdr_nav)
          else
            vim.notify('vim-herdr-navigation not installed, <C-hjkl> will not cross herdr panes', vim.log.levels.WARN)
          end
        end
      end,
    },
  }
end

return M
