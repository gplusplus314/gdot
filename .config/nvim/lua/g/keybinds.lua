-- Exported mappings:
local M = {}

local is_vscode = vim.g.vscode ~= nil

-- Stolen from: https://github.com/ThePrimeagen/.dotfiles/blob/master/nvim/.config/nvim/lua/theprimeagen/keymap.lua
local function bind(op, outer_opts)
  outer_opts = outer_opts or { noremap = true }
  return function(lhs, rhs, opts)
    opts = vim.tbl_extend("force", outer_opts, opts or {})
    vim.keymap.set(op, lhs, rhs, opts)
  end
end

vim.g.mapleader = " " -- Spacebar as leader

local nmap = bind("n", { noremap = false })
local nnoremap = bind "n"
local vnoremap = bind "v"
local xnoremap = bind "x"
local inoremap = bind "i"

-- Vim Keys in insert mode
--inoremap("<C-h>", "<Left>")
--inoremap("<C-j>", "<Down>")
--inoremap("<C-k>", "<Up>")
--inoremap("<C-l>", "<Right>")

-- Up and down using thumbs:
nnoremap("<CR>", "<Down>")
nnoremap("<BS>", "<Up>")

-- Fast project file switching:
nnoremap("`m", ':lua require("harpoon.mark").add_file()<CR>')
nnoremap("``", ':lua require("harpoon.ui").toggle_quick_menu()<CR>')
nnoremap("`0", ':lua require("harpoon.ui").nav_file(1)<CR>')
nnoremap("`1", ':lua require("harpoon.ui").nav_file(2)<CR>')
nnoremap("`2", ':lua require("harpoon.ui").nav_file(3)<CR>')
nnoremap("`3", ':lua require("harpoon.ui").nav_file(4)<CR>')

-- Keep visual selection while indenting:
vnoremap("<", "<gv")
vnoremap(">", ">gv")

-- Toggle file tree:
if is_vscode then
  nnoremap("<leader>.", "<Cmd>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<Cr>")
else
  nnoremap("<leader>.", ":NvimTreeFindFileToggle<cr>")
end

-- Paste without yank in visual mode:
vnoremap("p", '"_dP')

-- Copy visual selection to system clipboard:
vnoremap("<leader>y", '"+y')
-- Paste from system clipboard:
vnoremap("<leader>p", '"+p')
vnoremap("<leader>P", '"+P')

-- Move lines up and down in visual mode with <Shift>(up/down):
vnoremap("J", ":m '>+1<CR>gv=gv")
vnoremap("K", ":m '<-2<CR>gv=gv")
vnoremap("<S-Down>", ":m '>+1<CR>gv=gv")
vnoremap("<S-Up>", ":m '<-2<CR>gv=gv")

-- MarkdownPreview easy-mode
nnoremap("<leader>md", ":MarkdownPreviewToggle<CR>")

-- Toggle inline diagnostics
local inline_diagnostics_enabled = true
local function toggle_inline_diagnostics()
  inline_diagnostics_enabled = not inline_diagnostics_enabled
  vim.diagnostic.config { virtual_text = inline_diagnostics_enabled }
end
toggle_inline_diagnostics()
nnoremap("gl", toggle_inline_diagnostics)

-- Find things quickly
if is_vscode then
  nnoremap("<leader>ff", "<Cmd>call VSCodeNotify('find-it-faster.findFiles')<Cr>")
  nnoremap("<leader>fg", "<Cmd>call VSCodeNotify('find-it-faster.findWithinFiles')<Cr>")
else
  -- Telescope: https://github.com/nvim-telescope/telescope.nvim#usage
  nnoremap("<leader>ff", "<cmd>Telescope find_files<cr>")
  nnoremap("<leader>fg", "<cmd>Telescope live_grep<cr>")
  nnoremap("<leader> ", "<cmd>Telescope buffers<cr>")
  nnoremap("<leader>fh", "<cmd>Telescope help_tags<cr>")
  nnoremap("<leader>fp", "<cmd>Telescope project<cr>")
  nnoremap("<leader>ft", "<cmd>Telescope builtin<cr>")
end

-- Telescope Config Mappings:
M.telescope = {
  defaults = {
    i = {
      ["<Tab>"] = "move_selection_next",
      ["<S-Tab>"] = "move_selection_previous",
      ["<C-j>"] = "move_selection_next",
      ["<C-k>"] = "move_selection_previous",
      ["<C-u>"] = "preview_scrolling_up",
      ["<C-d>"] = "preview_scrolling_down",
      ["<Esc>"] = "close",
    },
  },
}


-- Easier split navigation:
nnoremap("<C-Left>", "<C-W>h")
nnoremap("<C-Down>", "<C-W>j")
nnoremap("<C-Up>", "<C-W>k")
nnoremap("<C-Right>", "<C-W>l")

-- CD to current file/buffer directory
nnoremap("<leader>cd", ":cd %:p:h<CR>")

-- Leap
require("leap").add_default_mappings()

-- Obsidian
nnoremap("<leader>fo", "<cmd>ObsidianSearch<CR>")
nnoremap("<leader>oo", "<cmd>ObsidianOpen<CR>")
nnoremap("<leader>or", "<cmd>ObsidianBacklinks<CR>")
nnoremap("<leader>ot", "<cmd>ObsidianToday<CR>")
vnoremap("<leader>ol", "<cmd>ObsidianLink<CR>")
nnoremap("<leader>of", "<cmd>ObsidianFollowLink<CR>")
vim.keymap.set("n", "gf", function()
  if require("obsidian").util.cursor_on_markdown_link() then
    return "<cmd>ObsidianFollowLink<CR>"
  else
    return "gf"
  end
end, { noremap = false, expr = true })
nnoremap("<leader>on", "<cmd>ObsidianNew ")
nnoremap("<leader>on", function()
  local name = vim.fn.input("Note Name: ", "", "file")
  vim.cmd("ObsidianNew " .. name)
end)

-- Debugging:
-- Convention: <leader>d = "leader Debug"
local dap = require "dap"
local dapui = require "dapui"
nnoremap("<leader>db", dap.toggle_breakpoint, { desc = "toggle Breakpoint" })
nnoremap("<leader>dc", dap.continue, { desc = "Continue" })
nnoremap("<leader>dt", require("dap-go").debug_test, { desc = "debug Test" })
nnoremap("<leader>dC", dap.run_last, { desc = "run most recent debug config" })
nnoremap("<leader>ds", dap.step_over, { desc = "Step over" })
nnoremap("<leader>di", dap.step_into, { desc = "step Into" })
nnoremap("<leader>do", dap.step_out, { desc = "step Out" })
nnoremap("<leader>dr", dap.repl.open, { desc = "toggle Repl" })
nnoremap("<leader>dB", function()
  dap.set_breakpoint(vim.fn.input "Breakpoint Condition: ")
end, { desc = "toggle conditional Breakpoint" })
nnoremap("<leader>dl", function()
  dap.set_breakpoint(vim.fn.input "Logpoint Message: ")
end, { desc = "Logpoint" })
nnoremap("<leader>dT", dap.terminate, { desc = "Terminate" })
nnoremap("<leader>du", dapui.toggle, { desc = "toggle debug Ui" })
nnoremap("<leader>dh", dap.run_to_cursor, { desc = "run to Here" })

-- Autocomplete
local cmp = require "cmp"
local luasnip = require "luasnip"
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end
M.cmp = {
  ["<CR>"] = cmp.mapping.confirm { select = true },
  ["<Up>"] = cmp.mapping.select_prev_item(),
  ["<Down>"] = cmp.mapping.select_next_item(),
  ["<C-k>"] = cmp.mapping.select_prev_item(),
  ["<C-j>"] = cmp.mapping.select_next_item(),
  ["<Esc>"] = cmp.mapping.abort(),
  ["<C-u>"] = cmp.mapping.scroll_docs(-4),
  ["<C-d>"] = cmp.mapping.scroll_docs(4),
  ["<C-Space>"] = cmp.mapping.complete(),
  ["<Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    elseif luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    elseif has_words_before() then
      cmp.complete()
    else
      fallback()
    end
  end, { "i", "s" }),
  ["<S-Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end, { "i", "s" }),
  ["<C-l>"] = cmp.mapping(function(fallback)
    if luasnip.jumpable(1) then
      luasnip.jump(1)
    else
      fallback()
    end
  end, { "i", "s" }),
  ["<C-h>"] = cmp.mapping(function(fallback)
    if luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end, { "i", "s" }),
}

M.apply_lspattach = function(bufmap)
  -- Displays hover information about the symbol under the cursor
  bufmap("n", "gh", "<cmd>lua vim.lsp.buf.hover()<cr>")

  -- Jump to the definition
  bufmap("n", "gd", '<cmd>lua require("telescope.builtin").lsp_definitions()<cr>')

  -- Jump to declaration
  bufmap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>")

  -- Lists all the implementations for the symbol under the cursor
  bufmap("n", "gi", '<cmd>lua require("telescope.builtin").lsp_implementations()<cr>')

  -- Jumps to the definition of the type symbol
  bufmap("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>")

  -- Lists all the references
  bufmap("n", "gr", '<cmd>lua require("telescope.builtin").lsp_references()<cr>')

  -- Displays a function's signature information
  bufmap("n", "K", "<cmd>lua vim.lsp.buf.signature_help()<cr>")
  bufmap("i", "<C-u>", "<cmd>lua vim.lsp.buf.signature_help()<cr>")

  -- Renames all references to the symbol under the cursor
  bufmap("n", "cs", "<cmd>lua vim.lsp.buf.rename()<cr>")

  -- Selects a code action available at the current cursor position
  bufmap("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<cr>")
  bufmap("x", "ga", "<cmd>lua vim.lsp.buf.range_code_action()<cr>")

  -- Show diagnostics in a floating window
  bufmap("n", "<leader>gl", "<cmd>lua vim.diagnostic.open_float()<cr>")

  -- Move to the previous diagnostic
  bufmap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")

  -- Move to the next diagnostic
  bufmap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")
end

M.apply_firenvim = function()
  nnoremap("<Esc>", ":wq<cr>")
end

M.apply_nvim_tree = function(bufnr)
  local inject_node = require("nvim-tree.utils").inject_node
  local api = require "nvim-tree.api"
  local nnoremap = bind("n", { buffer = bufnr })
  nnoremap(
    "<CR>",
    inject_node(function(node)
      if node.name == ".." or node.nodes then
        api.node.open.edit()
      else
        api.node.open.edit()
        vim.cmd "NvimTreeClose"
      end
    end)
  )
end

return M
