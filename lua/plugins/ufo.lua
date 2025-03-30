local ts = vim.treesitter

local function get_comment_blocks(bufnr)
  local parser = ts.get_parser(bufnr, nil)
  if parser == nil then
    return
  end
  local tree = parser:parse()[1]
  local root = tree:root()

  local comment_lines = {}

  -- Get the Treesitter query for comments (universal for most languages)
  local query = ts.query.parse(
    parser:lang(),
    [[
        (comment) @c
    ]]
  )

  for id, node in query:iter_captures(root, bufnr, 0, -1) do
    if query.captures[id] == 'c' then
      local start_row, _, end_row, _ = node:range()
      for l = start_row + 1, end_row + 1 do
        table.insert(comment_lines, l)
      end
    end
  end

  -- Group into contiguous blocks
  local blocks = {}
  local start = nil
  for _, lnum in ipairs(comment_lines) do
    if not start then
      start = lnum - 1
    end
    table.insert(blocks, { start, lnum })
    start = nil
  end

  return blocks
end

return {
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    event = 'VeryLazy',
    opts = {
      open_fold_hl_timeout = 400,
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

      vim.keymap.set('n', '<leader>fc', function()
        -- cache previous
        vim.b.comment_fold_enabled = vim.b.comment_fold_enabled or false
        if vim.b.comment_fold_enabled then
          require('ufo').openAllFolds()
          vim.b.comment_fold_enabled = false
          return
        end

        -- find all comment blocks
        local bufnr = vim.api.nvim_get_current_buf()
        local comment_blocks = get_comment_blocks(bufnr)
        if comment_blocks == nil then return end

        -- fold comment block
        for _, range in ipairs(comment_blocks) do
          vim.cmd(range[1] .. ',' .. range[2] .. 'fold')
        end
        vim.b.comment_fold_enabled = true
      end, { desc = '[f]old [c]omments' })
    end,
  },
}
