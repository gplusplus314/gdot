-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Load vimrc file as starting place for sane defaults
vim.cmd("source " .. vim.env.HOME .. "/.config/vim/vimrc")

if _G.config_mode == "pager" then
  vim.opt.scrolloff = 5
  vim.opt.relativenumber = false
  vim.opt.number = false
  vim.opt.list = false
  vim.opt.showtabline = 0

  -- Hide LSP noise since this is just a pager...
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    signs = false,
    virtual_text = false,
    update_in_insert = false,
    underline = false,
  })

  vim.api.nvim_command([[
    nnoremap q :qa!<CR> " quit like a pager would
    nnoremap i "" " disable getting into the command line in terminal mode
    nnoremap I "" " disable getting into the command line in terminal mode
    nnoremap a "" " disable getting into the command line in terminal mode
    nnoremap A "" " disable getting into the command line in terminal mode
    nnoremap <PageUp> 1000<C-U> " stop pageup from going past the buffer
    nnoremap <PageDown> 1000<C-D> " stop pagedown from going past the buffer
  ]])
end
