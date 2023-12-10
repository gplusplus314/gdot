-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

local function augroup(name)
  return vim.api.nvim_create_augroup("g_" .. name, { clear = true })
end

if not vim.g.vscode and not vim.env.EDITOR_INVOKED then
  vim.api.nvim_create_autocmd({ "VimEnter" }, {
    group = augroup("restore_session"),
    callback = function()
      -- Super nasty workaround for getting Globals to load from the
      -- session file in Windows. I don't care, it works. I have better things
      -- to do.
      local timer = vim.loop.new_timer()
      timer:start(
        1,
        0,
        vim.schedule_wrap(function()
          require("persistence").load()
        end)
      )
    end,
    nested = true,
  })
end
