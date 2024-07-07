-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Note: ~/.config/vim/vimrc is already sourced by the time we get here.
-- Add non-NeoVim-specific options and keybinds there so they can be
-- shared with other Vim implementations that can read a vimrc.

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local wk = require("which-key")

--{{{ Util
local function bind(op, outer_opts)
  outer_opts = outer_opts or { noremap = true, silent = true }
  return function(lhs, rhs, opts)
    opts = vim.tbl_extend("force", outer_opts, opts or {})
    vim.keymap.set(op, lhs, rhs, opts)
  end
end

local nnoremap = bind("n")
local vnoremap = bind("v")
local tnoremap = bind("t")
---}}}

--{{{ Basic movements and root-level binds

-- Buffer management:
nnoremap("<leader> ", "<cmd>Telescope buffers<cr>", { desc = "switch buffer" })
nnoremap("<C-W>", ":bdelete<cr>", { desc = "close buffer and switch" })
nnoremap("<S-Home>", ":BufferLineMovePrev<cr>", { desc = "swap previous buffer" })
nnoremap("<S-End>", ":BufferLineMoveNext<cr>", { desc = "swap next buffer" })
nnoremap("<C-P>", ":BufferLineTogglePin<cr>", { desc = "toggle buffer pin" })
nnoremap("<C-X>", ":BufferLineGroupClose ungrouped<cr>", { desc = "close all non-pinned buffers" })

-- Open Neotree to the current buffer's file:
nnoremap("<leader>e", ":Neotree toggle reveal<cr>", { desc = "open [e]xplorer" })

--}}}

--{{{ [o]ther
-- Copilot:
wk.register("<leader>o", { name = "[o]ther" })
local copilot_enabled = false
nnoremap("<leader>oc", function()
  copilot_enabled = not copilot_enabled
  if copilot_enabled then
    vim.notify("Copilot enabled", vim.log.levels.INFO, nil)
  else
    vim.notify("Copilot disabled", vim.log.levels.INFO, nil)
  end
end, { desc = "toggle [c]opilot" })

--}}}

--{{{ [s]earching:
wk.register({ s = { name = "[s]earch" } }, { prefix = "<leader>" })
nnoremap("<leader>sp", "<cmd>Telescope builtin<cr>", { desc = "telescope [p]ickers" })
nnoremap("<leader>sf", "<cmd>Telescope find_files<cr>", { desc = "find [f]iles" })
--}}}

return {
  is_copilot_enabled = function()
    return copilot_enabled
  end,
}
