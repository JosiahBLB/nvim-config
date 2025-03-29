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
            name = 'notes',
            path = '$HOME/Documents/obsidian-notes',
          },
        },
        daily_notes = {
          folder = 'daily-notes',
          default_tags = { 'daily-notes' },
        },
      }
      vim.keymap.set('n', '<leader>os', '<CMD>ObsidianQuickSwitch<CR>', { desc = '[o]bsidian [s]earch' })
      vim.keymap.set('n', '<leader>ow', '<CMD>ObsidianWorkspace<CR>', { desc = '[o]bsidian [w]orkspace' })
      vim.keymap.set('n', '<leader>on', '<CMD>ObsidianNew<CR>', { desc = '[o]bsidian [n]ew note' })
      vim.keymap.set('n', '<leader>ot', '<CMD>ObsidianTags<CR>', { desc = 'search [o]bsidian [t]ags' })
      vim.keymap.set('n', '<leader>oc', '<CMD>ObsidianCheck<CR>', { desc = 'search [o]bsidian [c]heck' })
      vim.keymap.set('n', 'gf', function()
        if require('obsidian').util.cursor_on_markdown_link() then
          return '<cmd>ObsidianFollowLink<CR>'
        else
          return 'gf'
        end
      end, { noremap = false, expr = true })

      vim.opt.conceallevel = 2
    end,
  },
}
