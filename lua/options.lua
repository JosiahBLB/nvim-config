-- [[ Setting options ]]
-- See `:help vim.opt`
--  For more options, you can see `:help option-list`

-- Defaults
vim.opt.mouse = "a" -- enable mouse mode
vim.opt.breakindent = true
vim.wo.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300                 -- mapped sequence wait time
vim.opt.completeopt = "menuone,noselect" -- better completion experience
vim.opt.termguicolors = true
vim.opt.splitright = true                -- vim-splits behaviour
vim.opt.splitbelow = true

-- Editor
vim.opt.number = true -- make line numbers default
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.showmode = true
vim.opt.incsearch = true
vim.opt.scrolloff = 8
vim.opt.hlsearch = false     -- highlight search
vim.opt.ignorecase = true    -- for searching
vim.opt.smartcase = true     -- case sensitive when capitals used
vim.opt.cursorline = true    -- highlight current line
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
vim.opt.undodir = os.getenv("HOME") .. "/.config/.vim/undodir"
vim.opt.undofile = true
vim.opt.isfname:append("@-@")

-- Specific file type settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.list = false
    vim.opt.conceallevel = 0
  end,
})

-- treesitter's syntax highlighting for tmux files sucks
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { ".tmux.conf", "*.tmux", "tmux.conf" },
  callback = function()
    vim.treesitter.language.register("bash", "tmux")  -- force tmux filetype to use bash parser
  end,
})

-- Set the path to java
local java_path = vim.fn.trim(vim.fn.system("which java"))
if java_path ~= "" and vim.fn.executable(java_path) == 1 then
  local java_bin = vim.fn.fnamemodify(java_path, ":h")
  local java_home = vim.fn.fnamemodify(java_bin, ":h")

  vim.env.JAVA_HOME = java_home
  vim.env.PATH = java_bin .. ":" .. vim.env.PATH
end

-- vim: ts=2 sts=2 sw=2 et
