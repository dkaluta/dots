local vim = vim
local g = vim.g
local wo = vim.wo
local set = vim.opt

require("config.lazy")



set.termguicolors = true
set.tabstop = 4
set.shiftwidth = 4
set.softtabstop = 4
set.expandtab = true
set.autoindent = true
wo.number = true
set.colorcolumn = "80"
vim.o.mouse = a
set.cursorline = true
set.ttyfast = true

vim.cmd [[colorscheme xcodehc]]
