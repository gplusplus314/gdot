local wk = require "which-key"

-- Exported mappings:
local M = {}

--{{{ Util
-- Stolen from: https://github.com/ThePrimeagen/.dotfiles/blob/master/nvim/.config/nvim/lua/theprimeagen/keymap.lua
local function bind(op, outer_opts)
  outer_opts = outer_opts or { noremap = true }
  return function(lhs, rhs, opts)
    opts = vim.tbl_extend("force", outer_opts, opts or {})
    vim.keymap.set(op, lhs, rhs, opts)
  end
end

local nmap = bind("n", { noremap = false })
local nnoremap = bind "n"
local vnoremap = bind "v"
local xnoremap = bind "x"
local inoremap = bind "i"
---}}}

--{{{ Basic movements and root-level binds

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
require("leap").add_default_mappings()

-- Save and quit in style!
nnoremap("ZZ", ":wqa<CR>")

--}}}

--{{{ Quick [t]oggles:
wk.register({ t = { name = "[t]oggle" } }, { prefix = "<leader>" })
nnoremap("<leader>tm", ":MarkdownPreviewToggle<CR>", { desc = "[m]arkdown preview" })
-- Toggle file tree:
nnoremap("<leader>.", ":NvimTreeToggle<cr>", { desc = "toggle file tree" })
nnoremap("<leader>tt", ":NvimTreeToggle<cr>", { desc = "file [t]ree" })
local dap = require "dap"
local dapui = require "dapui"
nnoremap("<leader>tD", dapui.toggle, { desc = "[D]ebug UI" })
-- Toggle inline diagnostics
local inline_diagnostics_enabled = true
local function toggle_inline_diagnostics()
  inline_diagnostics_enabled = not inline_diagnostics_enabled
  vim.diagnostic.config { virtual_text = inline_diagnostics_enabled }
end
toggle_inline_diagnostics()
nnoremap("<leader>ti", toggle_inline_diagnostics, { desc = "[i]nline diagnostics" })
--}}}

--{{{ [d]ebugging:
wk.register({ d = { name = "[d]ebug" } }, { prefix = "<leader>" })
nnoremap("<leader>db", dap.toggle_breakpoint, { desc = "toggle [b]reakpoint" })
nnoremap("<leader>dc", dap.continue, { desc = "[c]ontinue" })
nnoremap("<leader>dt", require("dap-go").debug_test, { desc = "debug [t]est" })
nnoremap("<leader>dC", dap.run_last, { desc = "run most recent debug [C]onfig" })
nnoremap("<leader>ds", dap.step_over, { desc = "[s]tep over" })
nnoremap("<leader>di", dap.step_into, { desc = "step [i]nto" })
nnoremap("<leader>do", dap.step_out, { desc = "step [o]ut" })
nnoremap("<leader>dr", dap.repl.open, { desc = "toggle [r]epl" })
nnoremap("<leader>dB", function()
  dap.set_breakpoint(vim.fn.input "Breakpoint Condition: ")
end, { desc = "toggle conditional [B]reakpoint" })
nnoremap("<leader>dl", function()
  dap.set_breakpoint(vim.fn.input "Logpoint Message: ")
end, { desc = "[l]ogpoint" })
nnoremap("<leader>dT", dap.terminate, { desc = "[T]erminate" })
nnoremap("<leader>du", dapui.toggle, { desc = "toggle debug [u]i" })
nnoremap("<leader>dh", dap.run_to_cursor, { desc = "run to [h]ere" })
--}}}

--{{{ [s]earching:
wk.register({ s = { name = "[s]earch" } }, { prefix = "<leader>" })
-- Telescope: https://github.com/nvim-telescope/telescope.nvim#usage
nnoremap("<leader>sf", "<cmd>Telescope find_files<cr>", { desc = "[f]iles" })
nnoremap("<leader>sg", "<cmd>Telescope live_grep<cr>", { desc = "live [g]rep" })
nnoremap("<leader> ", "<cmd>Telescope buffers<cr>", { desc = "search buffers" })
nnoremap("<leader>sb", "<cmd>Telescope buffers<cr>", { desc = "[b]uffers" })
nnoremap("<leader>sh", "<cmd>Telescope help_tags<cr>", { desc = "[h]elp" })
nnoremap("<leader>sp", "<cmd>Telescope project<cr>", { desc = "[p]roject" })
nnoremap("<leader>st", "<cmd>Telescope builtin<cr>", { desc = "[t]elescope" })
--}}}

--{{{ Other which-key labels
wk.register({ ["["] = { name = "previous" } }, { prefix = "" })
wk.register({ ["]"] = { name = "next" } }, { prefix = "" })
wk.register({ c = { name = "change" } }, { prefix = "" })
wk.register({ g = { name = "go to" } }, { prefix = "" })
--}}}

--{{{ Telescope Config Mappings
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
--}}}

--{{{ Obsidian
wk.register({ o = { name = "[o]bsidian" } }, { prefix = "<leader>" })
nnoremap("<leader>so", "<cmd>ObsidianSearch<CR>", { desc = "[o]bsidian" })
nnoremap("<leader>os", "<cmd>ObsidianSearch<CR>", { desc = "[s]earch" }) -- synonym ^^
nnoremap("<leader>oo", "<cmd>ObsidianOpen<CR>", { desc = "[o]open in obsidian" })
nnoremap("<leader>ob", "<cmd>ObsidianBacklinks<CR>", { desc = "[b]acklinks" })
nnoremap("<leader>oT", "<cmd>ObsidianToday<CR>", { desc = "[T]oday" })
vnoremap("<leader>ol", "<cmd>ObsidianLink<CR>", { desc = "[l]ink" })
nnoremap("<leader>of", "<cmd>ObsidianFollowLink<CR>", { desc = "[f]ollow link" })
vim.keymap.set("n", "gf", function()
  if require("obsidian").util.cursor_on_markdown_link() then
    return "<cmd>ObsidianFollowLink<CR>"
  else
    return "gf"
  end
end, { noremap = false, expr = true })
nnoremap("<leader>on", function()
  local name = vim.fn.input("Note Name: ", "", "file")
  if name ~= nil and name ~= "" then
    vim.cmd("ObsidianNew " .. name)
  end
end, { desc = "[n]ew note" })
local function insert_at_cursor(text)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { text })
end
wk.register({ t = { name = "[t]ask" } }, { prefix = "<leader>o" })
nnoremap("<leader>otl", function()
  insert_at_cursor "🔽"
end, { desc = "insert [l]ow priority" })
nnoremap("<leader>otm", function()
  insert_at_cursor "🔼"
end, { desc = "insert [m]edium priority" })
nnoremap("<leader>oth", function()
  insert_at_cursor "⏫"
end, { desc = "insert [h]igh priority" })
nnoremap("<leader>otd", function()
  insert_at_cursor "📅"
end, { desc = "insert [d]ue date" })
nnoremap("<leader>otr", function()
  insert_at_cursor "🔁"
end, { desc = "insert [r]ecurs" })
nnoremap("<leader>ots", function()
  insert_at_cursor "⏳"
end, { desc = "insert [s]cheduled" })
nnoremap("<leader>ota", function()
  insert_at_cursor("🛫 " .. os.date "%Y-%m-%d")
end, { desc = "insert st[a]rt" })
nnoremap("<leader>otf", function()
  insert_at_cursor("✅ " .. os.date "%Y-%m-%d")
end, { desc = "insert [f]inished" })
nnoremap("<leader>otT", function()
  local desc = vim.fn.input("task description: ", "")
  insert_at_cursor("- [ ] #task " .. desc)
end, { desc = "quick-insert [T]ask" })
nnoremap("<leader>ott", function()
  local desc = vim.fn.input("task description: ", "")
  local priority_choice = vim.fn.confirm("priority", "&normal\n&low\n&medium\n&high", 1)
  local priorities = { "", " 🔽", " 🔼", " ⏫" }
  local priority = priorities[priority_choice]
  local due = vim.fn.input("due date: ", "")
  if due ~= "" then
    due = " 📅 " .. due
  end
  local scheduled = vim.fn.input("scheduled: ", "")
  if scheduled ~= "" then
    scheduled = " ⏳ " .. scheduled
  end
  local recurs = vim.fn.input("recurs: ", "")
  if recurs ~= "" then
    recurs = " 🔁 " .. recurs
  end
  insert_at_cursor("- [ ] #task " .. desc .. priority .. due .. scheduled)
end, { desc = "scaffold [t]ask" })
--}}}

--{{{ CMP Autocomplete
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
    if luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    elseif cmp.visible() then
      cmp.select_next_item()
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
--}}}

--{{{ LSP Attach
M.apply_lspattach = function(bufmap)
  -- Displays hover information about the symbol under the cursor
  bufmap("n", "gh", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "[h]over" })

  -- Jump to the definition
  bufmap("n", "gd", '<cmd>lua require("telescope.builtin").lsp_definitions()<cr>', { desc = "[d]efinitions" })

  -- Jump to declaration
  bufmap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { desc = "[D]eclaration" })

  -- Lists all the implementations for the symbol under the cursor
  bufmap("n", "gi", '<cmd>lua require("telescope.builtin").lsp_implementations()<cr>', { desc = "[i]mplementations" })

  -- Jumps to the definition of the type symbol
  bufmap("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { desc = "[t]ype definition" })

  -- Lists all the references
  bufmap("n", "gr", '<cmd>lua require("telescope.builtin").lsp_references()<cr>', { desc = "[r]eferences" })

  -- Displays a function's signature information
  bufmap("n", "K", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { desc = "signature help" })
  bufmap("i", "<C-u>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { desc = "signature help" })

  -- Renames all references to the symbol under the cursor
  bufmap("n", "cs", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "[s]ymbol under cursor" })

  -- Selects a code action available at the current cursor position
  bufmap("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "code [a]ctions" })
  bufmap("x", "ga", "<cmd>lua vim.lsp.buf.range_code_action()<cr>", { desc = "code [a]ctions" })

  -- Show diagnostics in a floating window
  bufmap("n", "<leader>td", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "[d]iagnostics window" })

  -- Move to the previous diagnostic
  bufmap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", { desc = "[d]iagnostic" })

  -- Move to the next diagnostic
  bufmap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", { desc = "[d]iagnostic" })
end
--}}}

---{{{ FireNvim
M.apply_firenvim = function()
  nnoremap("<Esc>", ":wq<cr>")
end
--}}}

--{{{ Nvim Tree
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
--}}}

return M
