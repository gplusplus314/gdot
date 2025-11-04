-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Note: ~/.config/vim/vimrc is already sourced by the time we get here.
-- Add non-NeoVim-specific options and keybinds there so they can be
-- shared with other Vim implementations that can read a vimrc.

if _G.config_mode ~= "nvim" then
  return {}
end

local wk = require("which-key")

--{{{ Change some LazyVim defaults
-- These are already in my base vimrc, but LazyVim overwrites them.
wk.add({
  -- Split navigation with ctrl+arrows:
  { "<C-Left>", "<C-w>h", desc = "Navigate left" },
  { "<C-Down>", "<C-w>j", desc = "Navigate down" },
  { "<C-Up>", "<C-w>k", desc = "Navigate up" },
  { "<C-Right>", "<C-w>l", desc = "Navigate right" },
})
--}}}

--{{{ Buffer management:
wk.add({
  { "<Home>", "<cmd>BufferLineCyclePrev<cr>", desc = "cycle previous buffer" },
  { "<End>", "<cmd>BufferLineCycleNext<cr>", desc = "cycle previous buffer" },
  { "<S-Home>", "<cmd>BufferLineMovePrev<cr>", desc = "swap previous buffer" },
  { "<S-End>", "<cmd>BufferLineMoveNext<cr>", desc = "swap next buffer" },
  { "<leader>e", "<cmd>Neotree toggle reveal<cr>", desc = "open [e]xplorer" },
  { "<M-p>", "<cmd>BufferLineTogglePin<cr>", desc = "toggle [p]in" },
  { "<M-x>", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "close unpinned" },
})
--}}}

return {}
