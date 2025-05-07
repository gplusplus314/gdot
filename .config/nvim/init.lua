-- modes: nvim : default, full nvim
--   editor : Turns off IDE-like features and feels closer to vanilla Vim
--   pager : Makes Nvim act like a pager, somewhat.
--   vscode : VSCode extension for NeoVim integration
_G.config_mode = "nvim"
if vim.g.vscode then
  _G.config_mode = "vscode"
end

if _G.config_mode == "nvim" then
  -- If invoked without args or any piped stdin, restore the session
  -- automatically.
  local args = vim.fn.argv()
  if #args == 0 and not vim.g.started_with_stdin then
    vim.api.nvim_create_autocmd("VimEnter", {
      nested = true,
      once = true,
      callback = function()
        require("persistence").load()
      end,
    })
  end
end

-- bootstrap lazy.nvim, Lnoa zyVim and your plugins
require("config.lazy")
