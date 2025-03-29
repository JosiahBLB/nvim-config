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
  { 'numToStr/Comment.nvim', opts = {} }, -- default nvim uses /* */ rather than //
  require 'plugins/neogen', -- doxgen generation
  require 'plugins/nvim-colorizer', -- color hex values
  require 'plugins/lint', -- static analysis
  require 'plugins/transparent', -- adds window transparency
  require 'plugins/git', -- Git functionality
  require 'plugins/telescope', -- Fuzzy finding
  require 'plugins/lspconfig', -- Language server protocl config
  require 'plugins/conform', -- Auto formatting
  require 'plugins/cmp', -- completion sources
  require 'plugins/theme', -- editor colour scheme
  require 'plugins/todo-comments', -- coloured        TODO:
  require 'plugins/mini', -- grouped smaller plugins
  require 'plugins/treesitter', -- Highlight, edit, and navigate code
  require 'plugins/tmux', -- ctrl+<hjkl> to move between tmux panes
  require 'plugins/neo-tree', -- file navigator
  require 'plugins/indent-line', -- indentation guides
  require 'plugins/autopairs', -- match brackets
  require 'plugins/debug', -- debugging!
  require 'plugins/which-key', -- display key mappings
  require 'plugins/obsidian', -- obsidian integration
  require 'plugins/resession', -- nvim sessionizer
  require 'plugins/ufo', -- folds

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
