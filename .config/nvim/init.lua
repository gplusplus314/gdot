-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

local function augroup(name)
  return vim.api.nvim_create_augroup("g_" .. name, { clear = true })
end

if not vim.env.EDITOR_INVOKED then
  vim.api.nvim_create_autocmd({ "VimEnter" }, {
    group = augroup("restore_session"),
    callback = function()
      require("persistence").load()
    end,
    nested = true,
  })
end
