local snippets_mode = false
local copilot_mode = false

vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
  callback = function()
    snippets_mode = false
  end,
  desc = "Reset blink.cmp snippet mode state",
})

vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
  callback = function()
    copilot_mode = false
  end,
  desc = "Reset blink.cmp copilot mode state",
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
            if item.kind == require("blink.cmp.types").CompletionItemKind.Snippet then
              return snippets_mode
            end
            if item.source_id == "copilot" then
              return copilot_mode
            end
            return true
          end, items)
          return items
        end,
      },
      keymap = {
        ["<C-c>"] = {
          function()
            copilot_mode = not copilot_mode
            require("blink.cmp").cancel()
            vim.schedule(require("blink.cmp").show)
          end,
        },
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
