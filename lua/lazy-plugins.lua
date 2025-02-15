-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  To update plugins you can run
--    :Lazy update
--
-- Use `opts = {}` to force a plugin to be loaded.
--
require('lazy').setup({
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  'mg979/vim-visual-multi', -- ctrl+n for multi-cursors
  'xiyaowong/transparent.nvim', -- transparent background
  require 'plugins/gitsigns', -- Git signs to gutter
  require 'plugins/which-key', -- Display key mappings
  require 'plugins/telescope', -- Fuzzy finding
  require 'plugins/lspconfig', -- Language server protocl config
  require 'plugins/conform', -- Auto formatting
  require 'plugins/cmp', -- completion sources
  require 'plugins/theme', -- editor colour scheme
  require 'plugins/todo-comments', -- coloured        TODO:
  require 'plugins/mini', -- grouped smaller plugins
  require 'plugins/treesitter', -- Highlight, edit, and navigate code
  require 'plugins/tmux-navigator', -- ctrl+<hjkl> to move between tmux panes
  require 'plugins/neo-tree', -- file navigator
  require 'plugins/indent-line', -- indentation guides
  require 'plugins/autopairs', -- match brackets
  require 'plugins/debug', -- debugging!

  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use `<space>sh` then write `lazy.nvim-plugin`
}, {
  ui = {
    -- Use default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
