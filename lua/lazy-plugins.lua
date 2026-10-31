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

  -- theme
  require('plugins.theme.theme').init(), -- editor colour scheme
  require('plugins.theme.transparent').init(), -- adds window transparency
  require('plugins.theme.nvim-colorizer').init(), -- color hex values
  require('plugins.theme.indent-line').init(), -- indentation guides
  require('plugins.theme.todo-comments').init(), -- coloured        TODO:

  -- editor
  require('plugins.editor.autopairs').init(), -- match brackets
  require('plugins.editor.mini').init(), -- grouped smaller plugins
  require('plugins.editor.neoscroll').init(), -- smooth scroll
  require('plugins.editor.ufo').init(), -- folds
  require('plugins.editor.undotree').init(),
  require('plugins.editor.neogen').init(), -- doxgen generation
  require('plugins.editor.tmux').init(), -- ctrl+<hjkl> to move between tmux panes
  require('plugins.editor.which-key').init(), -- display key mappings

  -- navigation
  require('plugins.navigation.telescope').init(), -- Fuzzy finding
  require('plugins.navigation.neo-tree').init(), -- file navigator

  -- lsp
  require('plugins.lsp.lspconfig').init(), -- Language server protocl config
  require('plugins.lsp.cmp').init(), -- completion sources
  require('plugins.lsp.conform').init(), -- Auto formatting
  require('plugins.lsp.lint').init(), -- static analysis
  require('plugins.lsp.trouble').init(), -- diagnostics
  require('plugins.lsp.tree-sitter-manager').init(), -- Highlight, edit, and navigate code

  -- git
  require('plugins.git.git').init(), -- Git functionality

  -- debug
  require('plugins.debug.debug').init(), -- debugging!

  -- notes
  require('plugins.notes.obsidian').init(), -- obsidian integration
  require('plugins.notes.markdown-preview').init(), -- markdown preview
  require('plugins.notes.mermaid').init(), -- mermaid preview
  require('plugins.notes.image').init(), -- render images

  -- ai
  require('plugins.ai.claude').init(), -- claude code integration

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
