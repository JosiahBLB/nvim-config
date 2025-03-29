-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Keymaps for better default experience
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Screen centred half page jump down' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Screen centred half page jump up' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Screen centred jump to previous search term' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Screen centred jump to next search term' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set({ 'n', 'v', 'i' }, '<C-s>', '<cmd>w<CR>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>R', function()
  vim.cmd.source '$XDG_CONFIG_HOME/nvim/init.lua'
end, { desc = '[R]eload Neovim config' })
vim.keymap.set('n', '<leader>gg', '<cmd>!echo goodbye<cr>', { desc = '[R]eload Neovim config' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
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

-- Toggle inline diagnostics
vim.g.inline_diagnostics_enabled = true
function ToggleInlineDiagnostics()
  vim.g.inline_diagnostics_enabled = not vim.g.inline_diagnostics_enabled
  vim.diagnostic.config {
    virtual_text = vim.g.inline_diagnostics_enabled, -- Toggle inline warnings/errors
    signs = true, -- Keep gutter signs visible
    underline = vim.g.inline_diagnostics_enabled, -- Toggle underlining
  }
end
vim.keymap.set('n', '<leader>tw', ToggleInlineDiagnostics, { noremap = true, silent = true })
