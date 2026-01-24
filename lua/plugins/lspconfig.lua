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
        lua_ls = {
          on_init = function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
                return
              end
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
              runtime = {
                -- Tell the language server which version of Lua you're using (most
                -- likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Tell the language server how to find Lua modules same way as Neovim
                -- (see `:h lua-module-load`)
                path = {
                  'lua/?.lua',
                  'lua/?/init.lua',
                },
              },
              -- Make the server aware of Neovim runtime files
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                  -- Depending on the usage, you might want to add additional paths
                  -- here.
                  -- '${3rd}/luv/library',
                  -- '${3rd}/busted/library',
                },
                -- Or pull in all of 'runtimepath'.
                -- NOTE: this is a lot slower and will cause issues when working on
                -- your own configuration.
                -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                -- library = vim.api.nvim_get_runtime_file('', true),
              },
            })
          end,
          settings = {
            Lua = {},
          },
        },

        -- Functional
        nixd = {},
        ocamells = {},

        -- Web Dev
        gopls = {},
        ts_ls = {},
        html = {},
        denols = {},
        cssls = {},

        -- C++
        clangd = {},
        cmake = {
          filetypes = { 'cmake', 'CMakeLists.txt' },
        },

        -- Zig
        zls = {},

        -- Python
        ruff = {},
        ty = {},

        -- Mobile App Dev
        dartls = {
          flags = {
            allow_incremental_sync = false,
          },
          settings = {
            dart = {
              lineLength = 120,
            },
          },
        },

        -- Scripting
        awk_ls = {},
        bashls = {
          filetypes = { 'sh', 'zsh' },
        },

        -- Configuration files
        jsonls = {},
        lemminx = {}, -- xml
        yamlls = {},
      }

      for server, config in pairs(servers) do
        vim.lsp.enable(server)
        vim.lsp.config(server, config)
      end
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
