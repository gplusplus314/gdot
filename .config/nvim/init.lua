-- modes:
--   nvim : default, full nvim
--   editor : Turns off IDE-like features and feels closer to vanilla Vim
--   pager : Makes Nvim act like a pager, somewhat.
--   vscode : VSCode extension for NeoVim integration
_G.config_mode = "nvim"
if vim.g.vscode then
  _G.config_mode = "vscode"
end

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
