return {
  { 'tpope/vim-fugitive' }, -- git commands
  { 'tpope/vim-rhubarb' }, -- enables :GBrowse

  -- Adds git related signs to the gutter, as well as utilities for managing changes
  -- See `:help gitsigns`
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      signs_staged = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', '<leader>gp', function()
          if vim.wo.diff then
            vim.cmd.normal { '<leader>gp', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = '[G]it [P]revious Hunk' })
        map('n', '<leader>gn', function()
          if vim.wo.diff then
            vim.cmd.normal { '<leader>gn', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = '[G]it [N]ext Hunk' })

        -- Actions
        -- visual mode
        map('v', '<leader>gs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [s]tage hunk' })
        map('v', '<leader>gr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [r]eset hunk' })
        -- normal mode
        map('n', '<leader>gs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>gS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        map('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', '<leader>gd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        map('n', '<leader>gD', function()
          gitsigns.diffthis '@'
        end, { desc = 'git [D]iff against last commit' })
        map('n', '<leader>gq', ':only<CR>', { desc = '[g]it diff [q]uit' })
        -- Toggles
        map('n', '<leader>gb', gitsigns.toggle_current_line_blame, { desc = '[g]it [b]lame' })
        map('n', '<leader>td', gitsigns.preview_hunk_inline, { desc = '[t]oggle inline hunk [d]iff' })
        map('n', '<leader>tl', gitsigns.toggle_linehl, { desc = '[t]oggle [l]ine Highlights' })
        map('n', '<leader>tL', gitsigns.toggle_deleted, { desc = '[t]oggle Deleted [L]ine Highlights' })
        -- Other
        map('n', '<leader>gw', ':GBrowse<CR>', { desc = 'Open [g]it providers [w]ebview' })
      end,
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
