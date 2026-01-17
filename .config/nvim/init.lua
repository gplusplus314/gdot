-- modes:
--   nvim : default, full nvim
--   editor : Turns off IDE-like features and feels closer to vanilla Vim
--   vscode : VSCode extension for NeoVim integration
--   scrollback : nvim is being used as a Kitty terminal scrollback tool
_G.config_mode = "nvim"
if vim.g.vscode then
  _G.config_mode = "vscode"
end
if _G.config_mode == "nvim" and vim.env.KITTY_SCROLLBACK_NVIM == "true" then
  _G.config_mode = "scrollback"
end

require("config.lazy")
