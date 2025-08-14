-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Keymaps for better default experience
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Screen centred jump to previous search term' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Screen centred jump to next search term' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set({ 'n', 'v', 'i' }, '<C-s>', '<cmd>w<CR>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>R', function()
  vim.cmd.source '$XDG_CONFIG_HOME/nvim/init.lua'
end, { desc = '[R]eload Neovim config' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to next [D]iagnostic message' })
-- visual mode selection movement
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
-- pasting: set leader pasting to go to zero register
vim.keymap.set('x', '<leader>p', [["_d"0P]], { desc = 'Paste and replace selection from zero register' })
vim.keymap.set('n', '<leader>p', [["0p]], { desc = 'Paste from zero register' })
vim.keymap.set('n', '<leader>P', [["0P]], { desc = 'Paste from zero register' })
vim.keymap.set('v', 'p', [["_dP]], { desc = 'Paste from system clipboard without copying' })
-- copying: set leader copying to get to the zero register
vim.keymap.set({ 'n', 'v' }, '<M-c>', [["0y]], { desc = 'Yank to system clipboard' })
vim.keymap.set('n', '<leader>Y', [["0Y]], { desc = 'Yank to system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["0y]], { desc = 'Yank to system clipboard' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
--
-- Highlight when yanking
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Diagnostics on hover
vim.api.nvim_create_autocmd({ 'CursorHold' }, {
  pattern = '*',
  callback = function()
    for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_config(winid).zindex then
        return
      end
    end
    vim.diagnostic.open_float {
      scope = 'cursor',
      focusable = false,
      close_events = {
        'CursorMoved',
        'CursorMovedI',
        'BufHidden',
        'InsertCharPre',
        'WinLeave',
      },
    }
  end,
})

local function enable_diagnostics(enabled)
  vim.diagnostic.config {
    virtual_text = enabled,
    signs = true, -- Keep gutter signs visible
    underline = true,
  }
end

-- Toggle inline diagnostics
vim.g.inline_diagnostics_enabled = false
function ToggleInlineDiagnostics()
  vim.g.inline_diagnostics_enabled = not vim.g.inline_diagnostics_enabled
  enable_diagnostics(vim.g.inline_diagnostics_enabled)
end

-- Ensure they're disabled on attach
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function()
    enable_diagnostics(false)
  end,
})

vim.keymap.set('n', '<leader>tw', ToggleInlineDiagnostics, { noremap = true, silent = true })
