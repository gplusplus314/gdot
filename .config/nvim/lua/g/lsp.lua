local keybinds = require "g/keybinds"

-- Mason should be required before lspconfig:
require("mason").setup()
require("mason-lspconfig").setup()
local lspconfig = require "lspconfig"
local lsp_defaults = lspconfig.util.default_config


require("mason-lspconfig").setup_handlers {
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function (server_name) -- default handler (optional)
    lspconfig[server_name].setup {}
  end,
  -- Next, you can provide a dedicated handler for specific servers.
  -- For example, a handler override for the `gopls`:
  gopls = function ()
    lspconfig.gopls.setup {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    }
  end,
}


-- Merge sane defaults into capabilities config:
lsp_defaults.capabilities =
  vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

-- Configure what happens when an LSP attaches to a buffer:
vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function()
    local bufmap = function(mode, lhs, rhs, opts)
      if opts == nil then
        opts = {}
      end
      opts.buffer = true
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    keybinds.apply_lspattach(bufmap)
  end,
})

-- Autocompletion:
require("luasnip.loaders.from_vscode").lazy_load()
local luasnip = require "luasnip"
local cmp = require "cmp"
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  sources = {
    { name = "path" },
    { name = "nvim_lsp_signature_help" },
    { name = "nvim_lsp", keyword_length = 3 },
    { name = "buffer", keyword_length = 4 },
    -- {name = 'luasnip', keyword_length = 2},
  },

  window = {
    documentation = cmp.config.window.bordered(),
  },

  formatting = {
    fields = { "menu", "abbr", "kind" },
    format = function(entry, item)
      local menu_icon = {
        nvim_lsp = "L",
        luasnip = "S",
        buffer = "B",
        path = "~",
      }
      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },

  completion = {
    autocomplete = false,
  },

  mapping = keybinds.cmp,
}

-- Other config:
vim.diagnostic.config {
  virtual_text = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
}
