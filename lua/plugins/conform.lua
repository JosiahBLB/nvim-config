local M = {}

M.ensure_installed = {
  'clang-format', -- c/c++
  'stylua', -- lua
  'shfmt',
  'prettier',
  'markdownlint',
}

M.init = function()
  return {
    { -- Autoformat
      'stevearc/conform.nvim',
      event = { 'BufWritePre' },
      cmd = { 'ConformInfo' },
      keys = {
        {
          '<leader>fm',
          function()
            require('conform').format { async = true, lsp_format = 'fallback' }
          end,
          mode = '',
          desc = '[F]ormat buffer',
        },
      },
      opts = {
        notify_on_error = false,
        formatters_by_ft = {
          lua = { 'stylua' },
          cpp = { 'clang-format' },
          c = { 'clang-format' },
          cmake = { 'cmake_format' },
          python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports', 'docformatter' },
          markdown = { 'prettier', 'markdownlint', stop_after_first = true },
          bash = { 'shfmt' },
          sh = { 'shfmt' },
          go = { 'gofmt' }, -- via go
          xml = { 'xmlformatter', 'prettier' },
          html = { 'prettier' },
          ocaml = { 'ocamlformat' },

          -- Conform can also run multiple formatters sequentially
          -- python = { "isort", "black" },
          --
          -- You can use 'stop_after_first' to run the first available formatter from the list
          -- javascript = { "prettierd", "prettier", stop_after_first = true },
        },
        formatters = {
          docformatter = {
            command = 'docformatter',
            args = {
              '--in-place',
              '--blank',
              '--wrap-summaries',
              '120',
              '--wrap-descriptions',
              '120',
              '$FILENAME',
            },
            stdin = false,
          },
        },
      },
    },
  }
end

return M
-- vim: ts=2 sts=2 sw=2 et
