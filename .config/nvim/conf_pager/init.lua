vim.opt.runtimepath:remove(vim.fn.expand("~/.config/nvim"))
vim.opt.packpath:remove(vim.fn.expand("~/.local/share/nvim/site"))
vim.opt.runtimepath:append(vim.fn.expand("~/.config/nvim/conf_pager"))
vim.opt.packpath:append(vim.fn.expand("~/.local/share/nvim/conf_pager/site"))

local orig_stdpath = vim.fn.stdpath
vim.fn.stdpath = function(value)
  if value == "data" then
    return orig_stdpath("data") .. "/conf_pager"
  end
  return orig_stdpath(value)
end

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

require("lazy").setup({
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    config = function(_, _)
      require("flash").toggle(false)
    end,
    ---@type Flash.Config
    opts = {},
		-- stylua: ignore
		keys = {
			{ "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
			{ "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
			{ "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
			{ "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
			{ "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
		},
  },

  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
}, {})

require("catppuccin").setup({
  transparent_background = true, -- disables setting the background color.
})

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

-- set leader key to space
vim.g.mapleader = " "

vim.cmd.colorscheme("catppuccin-mocha")

--{{{ Pager-Specific things

vim.opt.scrolloff = 5
vim.opt.relativenumber = false
vim.opt.number = false
vim.opt.list = false
vim.opt.showtabline = 0

nnoremap("q", ":qa!<CR>") -- quit like a pager
nnoremap("i", "") -- disable getting into the command line in terminal mode
nnoremap("I", "") -- disable getting into the command line in terminal mode
nnoremap("a", "") -- disable getting into the command line in terminal mode
nnoremap("A", "") -- disable getting into the command line in terminal mode
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
