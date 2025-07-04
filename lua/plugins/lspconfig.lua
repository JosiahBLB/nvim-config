-- LSP Plugins
return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'p00f/clangd_extensions.nvim', opts = {} },

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by nvim-cmp
      'hrsh7th/cmp-nvim-lsp',

      -- Useful status updates for LSP.
      { 'onsails/lspkind.nvim', opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- Helper function to simplify defining LSP keymaps
          local map = function(keys, func, desc, mode)
            local opts = { buffer = event.buf, desc = 'LSP: ' .. desc }
            vim.keymap.set(mode or 'n', keys, func, opts)
          end

          -- Normal mode mappings
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gh', '<Cmd>ClangdSwitchSourceHeader<CR>', '[G]oto [H]eader (or source)')
          map('<leader>ast', '<Cmd>ClangdAST<CR>', 'Clangd [A]bstract [T]ype [H]ierarchy')
          map('<leader>cth', '<Cmd>ClangdTypeHierarchy<CR>', '[C]langd [T]ype [H]ierarchy')
          map('<leader>cm', '<Cmd>ClangdMemoryUsage<CR>', '[C]langd [M]emory usage')

          -- Normal + Visual mode mapping
          vim.keymap.set({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, {
            buffer = event.buf,
            desc = 'LSP: [C]ode [A]ction',
          })

          -- highlight references of the word under your cursor
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- toggle inlay hints in your code
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Change diagnostic symbols in the sign column (gutter)
      if vim.g.have_nerd_font then
        local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
        local diagnostic_signs = {}
        for type, icon in pairs(signs) do
          diagnostic_signs[vim.diagnostic.severity[type]] = icon
        end
        vim.diagnostic.config { signs = { text = diagnostic_signs } }
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      local servers = {
        -- `:help lspconfig-all` for a list of all the pre-configured LSPs
        bashls = {},
        clangd = {},
        ruff = {},
        pylsp = {},
        cmake = {
          filetypes = { 'cmake', 'CMakeLists.txt' },
        },
        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = {
                disable = { 'missing-fields' }, -- disable noisy warnings
                globals = { 'vim' },
              },
            },
          },
        },
        zls = {},
        pyright = {},
        lemminx = {}, -- xml
        gopls = {},
        html = {},
      }

      -- Ensure the servers and tools above are installed
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, require('plugins.lint').ensure_installed)
      vim.list_extend(ensure_installed, require('plugins.conform').ensure_installed)
      vim.list_extend(ensure_installed, require('plugins.debug').ensure_installed)
      vim.list_extend(ensure_installed, {
        'bash-language-server', -- bashls
        'cmake-language-server', -- cmake
        'lua-language-server', -- lua_ls
      })

      -- deduplicate the list
      local set = {}
      for _, v in ipairs(ensure_installed) do
        set[v] = true
      end
      ensure_installed = {}
      for k in pairs(set) do
        table.insert(ensure_installed, k)
      end

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed by the server configuration above
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }

      -- Manual entries for those which are not handled by mason
      require('lspconfig').dartls.setup {}
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
