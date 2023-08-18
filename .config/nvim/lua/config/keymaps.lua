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
nnoremap("<C-X>", ":BufferLineGroupClose ungrouped<cr>", { desc = "close all non-pinned buffers" })

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

-- CD to current file/buffer directory
nnoremap("<leader>cd", ":cd %:p:h<CR>")

-- Leap
--require("leap").add_default_mappings()

-- Save and quit in style!
nnoremap("ZZ", ":wqa<CR>")

-- GTFO the embedded terminal
tnoremap("<esc>", "<C-\\><C-N>")

--}}}

--{{{ Quick [t]oggles:
wk.register({ t = { name = "[t]oggle" } }, { prefix = "<leader>" })
nnoremap("<leader>tw", ":set wrap!<cr>", { desc = "text [w]rap" })
nnoremap("<leader>tm", ":MarkdownPreviewToggle<CR>", { desc = "[m]arkdown preview" })
-- Toggle inline diagnostics
local inline_diagnostics_enabled = true
local function toggle_inline_diagnostics()
  inline_diagnostics_enabled = not inline_diagnostics_enabled
  vim.diagnostic.config({ virtual_text = inline_diagnostics_enabled })
end
toggle_inline_diagnostics()
nnoremap("<leader>ti", toggle_inline_diagnostics, { desc = "[i]nline diagnostics" })
-- Copilot:
local copilot_enabled = true
nnoremap("<leader>tc", function()
  if copilot_enabled then
    vim.cmd("Copilot disable")
    vim.notify("Copilot disabled", vim.log.levels.INFO, nil)
  else
    vim.cmd("Copilot enable")
    vim.notify("Copilot enabled", vim.log.levels.INFO, nil)
  end
  copilot_enabled = not copilot_enabled
end, { desc = "[c]opilot" })

--}}}

--{{{ [s]earching:
wk.register({ s = { name = "[s]earch" } }, { prefix = "<leader>" })
nnoremap("<leader>sp", "<cmd>Telescope builtin<cr>", { desc = "telescope [p]ickers" })
nnoremap("<leader>sf", "<cmd>Telescope find_files<cr>", { desc = "find [f]iles" })
--}}}

--{{{ [T]esting:
wk.register({ T = { name = "[T]esting" } }, { prefix = "<leader>" })
--}}}
