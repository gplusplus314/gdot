return {
  -- Use <tab> for completion and snippets (supertab)
  -- first: disable default <tab> and <s-tab> behavior in LuaSnip
  --{
  --  "L3MON4D3/LuaSnip",
  --  keys = function()
  --    return {}
  --  end,
  --},
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      for _, source in ipairs(opts.sources) do
        if source.name == "copilot" then
          source.entry_filter = require("config.keymaps").is_copilot_enabled
          break
        end
      end

      --local has_words_before = function()
      --  unpack = unpack or table.unpack
      --  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      --  return col ~= 0
      --    and vim.api
      --        .nvim_buf_get_lines(0, line - 1, line, true)[1]
      --        :sub(col, col)
      --        :match("%s")
      --      == nil
      --end

      --local luasnip = require("luasnip")
      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-U>"] = cmp.mapping.scroll_docs(-4),
        ["<C-D>"] = cmp.mapping.scroll_docs(4),
        --["<Tab>"] = cmp.mapping(function(fallback)
        --  if cmp.visible() then
        --    -- This completes the first/top match without closing the completion
        --    -- window and without going to the next item, but only for the first
        --    -- time we hit tab. All subsequent tabs select and complete the
        --    -- next item.
        --    if not cmp.get_active_entry() then
        --      -- if only one extry exists, confirm it
        --      if #cmp.get_entries() == 1 then
        --        cmp.confirm()
        --      else
        --        -- otherwize, select and insert the first one
        --        cmp.select_next_item({ count = 0 })
        --      end
        --    else
        --      cmp.select_next_item()
        --    end
        --    -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
        --    -- this way you will only jump inside the snippet region
        --  elseif luasnip.expand_or_locally_jumpable() then
        --    luasnip.expand_or_jump()
        --  elseif has_words_before() then
        --    cmp.complete()
        --  else
        --    fallback()
        --  end
        --end, { "i", "s" }),
        --["<S-Tab>"] = cmp.mapping(function(fallback)
        --  if cmp.visible() then
        --    cmp.select_prev_item()
        --  elseif luasnip.jumpable(-1) then
        --    luasnip.jump(-1)
        --  else
        --    fallback()
        --  end
        --end, { "i", "s" }),
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
  },
}
