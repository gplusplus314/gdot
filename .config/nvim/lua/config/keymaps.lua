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

--{{{ Undo insane LazyVim defaults:
nnoremap("f", "f")
nnoremap("F", "F")
nnoremap("t", "t")
nnoremap("T", "T")
nnoremap("/", "/")
nnoremap("gw", "gw")
nnoremap("gW", "gW")
nnoremap(";", ";")
nnoremap(",", ",")
--}}}

--{{{ Basic movements and root-level binds

-- Up and down using thumb:
nnoremap("<CR>", "<Down>")
nnoremap("<BS>", "<Up>")

-- Buffer management:
nnoremap("<leader> ", "<cmd>Telescope buffers<cr>", { desc = "switch buffer" })
nnoremap("<C-W>", ":bdelete<cr>", { desc = "close buffer and switch" })
nnoremap("<Home>", ":BufferLineCyclePrev<cr>", { desc = "previous buffer" })
nnoremap("<End>", ":BufferLineCycleNext<cr>", { desc = "next buffer" })
nnoremap("<S-Home>", ":BufferLineMovePrev<cr>", { desc = "previous buffer" })
nnoremap("<S-End>", ":BufferLineMoveNext<cr>", { desc = "next buffer" })
nnoremap("<C-P>", ":BufferLineTogglePin<cr>", { desc = "toggle buffer pin" })
nnoremap(
  "<C-X>",
  ":BufferLineGroupClose ungrouped<cr>",
  { desc = "close all non-pinned buffers" }
)

-- Keep visual selection while indenting:
vnoremap("<", "<gv")
vnoremap(">", ">gv")

-- Paste without yank in visual mode:
vnoremap("p", '"_dP')

-- Copy visual selection to system clipboard:
vnoremap("<leader>y", '"+y')
-- Paste from system clipboard:
vnoremap("<leader>p", '"+p')
vnoremap("<leader>P", '"+P')

-- Move lines up and down in visual mode with <Shift>(up/down):
vnoremap("<S-Down>", ":m '>+1<CR>gv=gv")
vnoremap("<S-Up>", ":m '<-2<CR>gv=gv")

-- Delete characters without clobbering default register:
nnoremap("x", '"_x')
nnoremap("X", '"_X')

-- Easier split navigation:
nnoremap("<C-Left>", "<C-W>h")
nnoremap("<C-Down>", "<C-W>j")
nnoremap("<C-Up>", "<C-W>k")
nnoremap("<C-Right>", "<C-W>l")

-- Save and quit in style!
nnoremap("ZZ", ":wqa<CR>")

-- GTFO the embedded terminal
tnoremap("<esc>", "<C-\\><C-N>")

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
nnoremap(
  "<leader>sp",
  "<cmd>Telescope builtin<cr>",
  { desc = "telescope [p]ickers" }
)
nnoremap(
  "<leader>sf",
  "<cmd>Telescope find_files<cr>",
  { desc = "find [f]iles" }
)
--}}}

return {
  is_copilot_enabled = function()
    return copilot_enabled
  end,
}
