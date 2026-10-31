local M = {}

M.ensure_installed = {
  'vulture', -- python
  'cmakelint',
  'cpplint',
  'hadolint', -- docker
  'jsonlint',
  'shellcheck',
  'markdownlint',
  'yamllint'
}

M.init = function()
  return {
    { -- Linting
      'mfussenegger/nvim-lint',
      event = { 'BufReadPre', 'BufNewFile' },
      config = function()
        local lint = require 'lint'
        lint.linters.shellcheck.args = { '-x' }
        lint.linters_by_ft = {
          markdown = { 'markdownlint' },
          dockerfile = { 'hadolint' },
          json = { 'jsonlint' },
          cpp = { 'cpplint' },
          c = { 'cpplint' },
          cmake = { 'cmakelint' },
          python = { 'ruff', 'mypy', 'vulture' },
          sh = { 'shellcheck' },
          bash = { 'shellcheck' },
          zsh = { 'shellcheck' },
          yaml = { 'yamllint' },
        }

        -- Create autocommand which carries out the actual linting
        -- on the specified events.
        local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
        vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
          group = lint_augroup,
          callback = function()
            -- Only run the linter in buffers that you can modify in order to
            -- avoid superfluous noise, notably within the handy LSP pop-ups that
            -- describe the hovered symbol using Markdown.
            if vim.opt_local.modifiable:get() then
              lint.try_lint()
            end
          end,
        })
      end,
    },
  }
end

return M
