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
  { "<leader> ", "<cmd>Telescope buffers<cr>", desc = "switch buffer" },
  { "<C-W>", ":bdelete<cr>", desc = "close buffer and switch" },
  { "<Home>", ":BufferLineCyclePrev<cr>", desc = "cycle previous buffer" },
  { "<End>", ":BufferLineCycleNext<cr>", desc = "cycle previous buffer" },
  { "<S-Home>", ":BufferLineMovePrev<cr>", desc = "swap previous buffer" },
  { "<S-End>", ":BufferLineMoveNext<cr>", desc = "swap next buffer" },
  { "<C-P>", ":BufferLineTogglePin<cr>", desc = "toggle buffer pin" },
  { "<C-U>", ":BufferLineGroupClose ungrouped<cr>", desc = "close all [U]ngrouped (non-pinned) buffers" },
  { "<leader>e", ":Neotree toggle reveal<cr>", desc = "open [e]xplorer" },
})
--}}}

--{{{ [s]earching:
vim.keymap.set("n", "<leader>sx", require("telescope.builtin").resume, {
  noremap = true,
  silent = true,
  desc = "Resume",
})
wk.add({
  { "<leader>sp", "<cmd>Telescope builtin<cr>", desc = "telescope [p]ickers" },
  { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "find [f]iles" },
})
--}}}

return {}
