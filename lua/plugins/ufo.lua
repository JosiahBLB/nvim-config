return {
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    event = 'VeryLazy',
    opts = {
      -- INFO: Uncomment to use treeitter as fold provider, otherwise nvim lsp is used
      -- provider_selector = function(bufnr, filetype, buftype)
      --   return { "treesitter", "indent" }
      -- end,
      open_fold_hl_timeout = 400,
      close_fold_kinds_for_ft = {
        default = { 'comment' }, -- keep comments closed
      },
      preview = {
        win_config = {
          border = { '', '─', '', '', '', '─', '', '' },
          winhighlight = 'Normal:Folded',
          winblend = 0,
        },
      },
    },
    init = function()
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.o.foldcolumn = '0' -- '0' is not bad
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      local c = require('vscode.colors').get_colors()
      vim.api.nvim_set_hl(0, 'UfoInvisiblePadding', {
        fg = c.vscSplitDark,
        bg = 'NONE',
        ctermfg = 'NONE',
        ctermbg = 'NONE',
        default = true,
      })
    end,

    config = function(_, opts)
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local totalLines = vim.api.nvim_buf_line_count(0)
        local foldedLines = endLnum - lnum
        local suffix = ('  %d %d%%'):format(foldedLines, math.floor(foldedLines / totalLines * 100))
        local sufWidth = vim.fn.strdisplaywidth(suffix)

        -- Calculate current width of the existing fold text
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          curWidth = curWidth + vim.fn.strdisplaywidth(chunk[1])
        end

        -- Truncate if necessary to make space for suffix
        local targetWidth = vim.api.nvim_win_get_width(0) - sufWidth - 1
        curWidth = 0
        for _, chunk in ipairs(virtText) do
          local text, hl = chunk[1], chunk[2]
          local textWidth = vim.fn.strdisplaywidth(text)

          if curWidth + textWidth < targetWidth then
            table.insert(newVirtText, { text, hl })
          else
            text = truncate(text, targetWidth - curWidth)
            table.insert(newVirtText, { text, hl })
            break
          end

          curWidth = curWidth + textWidth
        end

        -- Pad spaces to right-align the suffix
        local padding = vim.api.nvim_win_get_width(0) - curWidth - sufWidth - 8
        if padding > 0 then
          table.insert(newVirtText, { string.rep(' ', padding), 'UfoInvisiblePadding' })
        end
        table.insert(newVirtText, { suffix, 'UfoInvisiblePadding' })
        return newVirtText
      end
      opts['fold_virt_text_handler'] = handler
      require('ufo').setup(opts)
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
      vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
      vim.keymap.set('n', 'K', function()
        local winid = require('ufo').peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end)
    end,
  },
}
