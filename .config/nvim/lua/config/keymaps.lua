-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Note: ~/.config/vim/vimrc is already sourced by the time we get here.
-- Add non-NeoVim-specific options and keybinds there so they can be
-- shared with other Vim implementations that can read a vimrc.

local wk = require("which-key")

--{{{ Buffer management:
wk.add({
  { "<leader> ", "<cmd>Telescope buffers<cr>", desc = "switch buffer" },
  { "<C-W>", ":bdelete<cr>", desc = "close buffer and switch" },
  { "<S-Home>", ":BufferLineMovePrev<cr>", desc = "swap previous buffer" },
  { "<S-End>", ":BufferLineMoveNext<cr>", desc = "swap next buffer" },
  { "<C-P>", ":BufferLineTogglePin<cr>", desc = "toggle buffer pin" },
  { "<C-X>", ":BufferLineGroupClose ungrouped<cr>", desc = "close all non-pinned buffers" },
  { "<leader>e", ":Neotree toggle reveal<cr>", desc = "open [e]xplorer" },
})
--}}}

--{{{ [a]i
-- Copilot:
local copilot_enabled = false
wk.add({
  {
    "<leader>ac",
    function()
      copilot_enabled = not copilot_enabled
      if copilot_enabled then
        vim.notify("Copilot enabled", vim.log.levels.INFO, nil)
      else
        vim.notify("Copilot disabled", vim.log.levels.INFO, nil)
      end
    end,
    desc = "toggle [c]ompletions",
  },
})
--}}}

--{{{ [s]earching:
wk.add({
  { "<leader>sp", "<cmd>Telescope builtin<cr>", desc = "telescope [p]ickers" },
  { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "find [f]iles" },
})
--}}}

return {
  is_copilot_enabled = function()
    return copilot_enabled
  end,
}
