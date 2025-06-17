local snippets_mode = false
vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
  callback = function()
    snippets_mode = false
  end,
  desc = "Reset blink.cmp snippet mode state",
})
return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        ghost_text = {
          enabled = false,
        },
      },
      sources = {
        transform_items = function(_, items)
          items = vim.tbl_filter(function(item)
            return (item.kind == require("blink.cmp.types").CompletionItemKind.Snippet) == snippets_mode
          end, items)
          return items
        end,
      },
      keymap = {
        ["<C-t>"] = {
          function()
            snippets_mode = not snippets_mode
            require("blink.cmp").cancel()
            vim.schedule(require("blink.cmp").show)
          end,
        },
      },
    },
  },
}
