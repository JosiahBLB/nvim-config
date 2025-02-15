-- [[ Setting options ]]
-- See `:help vim.opt`
--  For more options, you can see `:help option-list`

-- Defaults
vim.opt.mouse = "a" -- enable mouse mode
vim.opt.breakindent = true
vim.wo.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300 -- mapped sequence wait time
vim.opt.completeopt = "menuone,noselect" -- better completion experience
vim.opt.termguicolors = true
vim.opt.splitright = true -- vim-splits behaviour
vim.opt.splitbelow = true

-- Editor
vim.opt.number = true -- make line numbers default
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.showmode = true
vim.opt.incsearch = true
vim.opt.scrolloff = 8
vim.opt.hlsearch = false -- highlight search
vim.opt.ignorecase = true -- for searching
vim.opt.smartcase = true -- case sensitive when capitals used
vim.opt.cursorline = true -- highlight current line
vim.opt.inccommand = "split" -- live substitutions

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- History
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.comfig/.vim/undodir"
vim.opt.undofile = true
vim.opt.isfname:append("@-@")

-- vim: ts=2 sts=2 sw=2 et
