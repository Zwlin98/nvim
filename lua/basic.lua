vim.o.termguicolors = true

vim.o.mouse = "a"

vim.o.hidden = true

vim.o.title = true

vim.o.undofile = true

vim.o.cursorline = true

vim.o.pumblend = 12

vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.smartcase = true

vim.o.number = true
vim.o.relativenumber = true

vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftround = true
vim.o.shiftwidth = 4
vim.o.smartindent = true
vim.o.autoindent = true

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.linebreak = true
vim.o.signcolumn = "yes"
vim.o.textwidth = 120
vim.o.wrap = false
vim.o.showbreak = ">>"
vim.o.fillchars = "diff:╱"

vim.o.scrolloff = 2
vim.o.sidescrolloff = 5

vim.g.mapleader = " "

vim.o.updatetime = 300
vim.o.timeoutlen = 400

vim.o.list = true
vim.opt.listchars = { leadmultispace = "│ ", multispace = "│ ", tab = "│ " }
vim.o.exrc = true

vim.cmd([[set diffopt+=vertical]])
vim.cmd([[set clipboard+=unnamedplus]])
-- host specific settings
local rikka = require("rikka")
if rikka.isLocal() then
    vim.g.python3_host_prog = "~/.config/nvim/nvim-python/bin/python3"
end
