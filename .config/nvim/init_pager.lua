local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(
  -- plugins
  {
    "m00qek/baleia.nvim",
  },
  -- opts
  {}
)

--require("baleia").setup({})
--vim.cmd([[
--let s:baleia = luaeval("require('baleia').setup { }")
--function! BaleiaColorize()
--	setlocal modifiable
--	let s:baleia = luaeval("require('baleia').setup({})")
--	command! BaleiaColorize call s:baleia.once(bufnr('%'))
--	setlocal nomodifiable
--endfunction
--command! -buffer BaleiaColorize call BaleiaColorize()
--]])

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

--{{{ Pager-Specific things

vim.opt.modifiable = false
vim.o.scrolloff = 10

nnoremap("q", ":qa!<CR>") -- quit like a pager
nnoremap("i", "") -- disable getting into the command line in terminal mode
nnoremap("<PageUp>", "1000<C-U>") -- stop pageup from going past the buffer
nnoremap("<PageDown>", "1000<C-D>") -- stop pagedown from going past the buffer

--}}}

--{{{ Basic movements and root-level binds

-- Up and down using thumb:
nnoremap("<CR>", "<Down>")
nnoremap("<BS>", "<Up>")

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

--}}}

-- if nvimpager exists...
if vim.fn.exists("g:nvimpager") == 1 then
  -- Disable nvimpager default keymaps
  nvimpager.maps = false
end
