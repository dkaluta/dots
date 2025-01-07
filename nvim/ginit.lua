local vim = vim
local set = vim.opt

local default_path = vim.fn.expand("~/dev")
vim.api.nvim_set_current_dir(default_path)


set.lines=70
set.columns=200
set.guifont="SF\ Mono:h12"
