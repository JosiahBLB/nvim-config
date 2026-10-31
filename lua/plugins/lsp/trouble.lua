local M = {}

M.init = function()
  return {
    'folke/trouble.nvim',
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = 'Trouble',
    keys = {
      {
        '<leader>e',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>cs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>cl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      {
        '<leader>xL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>q',
        function()
          -- Find first occurrence of "error.err"
          local handle = io.popen("find . -type f -name 'errors.err' | head -n 1")
          if not handle then
            vim.notify("Error searching for errors.err", vim.log.levels.ERROR)
            return
          end

          local path = handle:read("*l")  -- Read first line
          handle:close()

          if path and path ~= "" then
            -- Load quickfix list from the found file
            vim.cmd("cfile " .. vim.fn.fnameescape(path))
            -- Optionally toggle Trouble's quickfix list
            vim.cmd("Trouble qflist toggle")
          else
            vim.notify("No errors.err file found", vim.log.levels.WARN)
          end
        end,
        desc = 'Open first errors.err in Quickfix (Trouble)',
      }
    },
  }
end

return M
