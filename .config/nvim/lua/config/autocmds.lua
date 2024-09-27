-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

if _G.config_mode ~= "nvim" then
  return
end

vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("restore_session", { clear = true }),
  callback = function()
    if vim.fn.getcwd() ~= vim.env.HOME then
      require("persistence").load()
    end
  end,
  nested = true,
})
