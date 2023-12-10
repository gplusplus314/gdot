-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local o = vim.opt

o.scrolloff = 20
o.colorcolumn = "80"
o.cursorline = true
o.foldmethod = "marker"
o.textwidth = 80
o.expandtab = false
o.sessionoptions = "buffers,curdir,tabpages,winsize,globals,skiprtp,folds"

vim.lsp.set_log_level("debug")
