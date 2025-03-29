return {
  {
    'epwalsh/obsidian.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('obsidian').setup {
        workspaces = {
          {
            name = 'personal',
            path = '$HOME/Documents/obsidian-notes/personal',
          },
          {
            name = 'gspace',
            path = '$HOME/Documents/obsidian-notes/gspace',
          },
        },
      }
      vim.keymap.set('n', '<leader>os', '<CMD>ObsidianQuickSwitch<CR>', { desc = '[o]bsidian [s]earch' })
      vim.keymap.set('n', '<leader>ow', '<CMD>ObsidianWorkspace<CR>', { desc = '[o]bsidian [w]orkspace' })
      vim.keymap.set('n', '<leader>on', '<CMD>ObsidianNew<CR>', { desc = '[o]bsidian [n]ew note' })
      vim.keymap.set('n', '<leader>ot', '<CMD>ObsidianTags<CR>', { desc = 'search [o]bsidian [t]ags' })
      vim.opt.conceallevel = 2
    end,
  },
}
