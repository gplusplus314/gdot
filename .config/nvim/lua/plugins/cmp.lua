return {
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    for _, source in ipairs(opts.sources) do
      if source.name == "copilot" then
        source.entry_filter = require("config.keymaps").is_copilot_enabled
        break
      end
    end

    local cmp = require("cmp")
    local luasnip = require("luasnip")
    opts.mapping = vim.tbl_extend("force", opts.mapping, {
      ["<C-U>"] = cmp.mapping.scroll_docs(-4),
      ["<C-D>"] = cmp.mapping.scroll_docs(4),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif cmp.visible() then
          cmp.confirm({ select = true })
        else
          fallback()
        end
      end, { "i", "s" }),

      -- Get copilot-specific completion on-demand
      ["<C-C>"] = cmp.mapping.complete({
        --@diagnostic disable-next-line: missing-fields
        config = {
          sources = {
            { name = "copilot" },
          },
        },
      }),
    })
  end,
}
