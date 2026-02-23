return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- See `:help ibl`
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    main = 'ibl',
    config = function()
      vim.api.nvim_set_hl(0, 'Function', { fg = '#ff0000' })

      require('ibl').setup {
        indent = {
          char = '▏',
        },
        scope = {
          enabled = true,
          show_start = true,
          show_end = true,
          highlight = { 'Function' },
        },
      }
    end,
    opts = {
      indent = { char = '▏' },
      scope = {
        enabled = false,
      },
    },
  },
}
