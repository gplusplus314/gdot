return {
  {
    "nvim-neotest/neotest",
    opts = {
      -- Can be a list of adapters like what neotest expects,
      -- or a list of adapter names,
      -- or a table of adapter names, mapped to adapter configs.
      -- The adapter will then be automatically loaded with the config.
      adapters = {},
      -- Example for loading neotest-go with a custom config
      -- adapters = {
      --   ["neotest-go"] = {
      --     args = { "-tags=integration" },
      --   },
      -- },
      status = { virtual_text = true },
      output = { open_on_run = true },
      quickfix = {
        open = function()
          if require("lazyvim.util").has("trouble.nvim") then
            vim.cmd("Trouble quickfix")
          else
            vim.cmd("copen")
          end
        end,
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>Tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
      { "<leader>TT", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Run All Test Files" },
      { "<leader>Tr", function() require("neotest").run.run() end, desc = "Run Nearest" },
      { "<leader>Ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
      { "<leader>To", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
      { "<leader>TO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
      { "<leader>TS", function() require("neotest").run.stop() end, desc = "Stop" },
    },
  },

  {
    "mfussenegger/nvim-dap",
    optional = true,
    -- stylua: ignore
    keys = {
      { "<leader>Td", function() require("neotest").run.run({strategy = "dap"}) end, desc = "Debug Nearest" },
    },
  },

  {
    "folke/persistence.nvim",
    lazy = false,
    cond = not vim.env.EDITOR_INVOKED,
    event = "BufReadPre",
    opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" } },
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },

  {
    "akinsho/bufferline.nvim",
    keys = nil,
    lazy = false,
    opts = {
      options = {
        show_close_icon = false,
        indicator = {
          style = "underline",
        },
      },
    },
  },

  {
    "echasnovski/mini.surround",
    opts = {
      -- Add custom surroundings to be used on top of builtin ones. For more
      -- information with examples, see `:h MiniSurround.config`.
      custom_surdings = nil,

      -- Module mappings. Use `` (empty string) to disable one.
      mappings = {
        add = "ys", -- Add surrounding in Normal and Visual modes
        delete = "ds", -- Delete surrounding
        find = "''", -- Find surrounding (to the right)
        find_left = "''", -- Find surrounding (to the left)
        highlight = "sh", -- Highlight surrounding
        replace = "cs", -- Replace surrounding
        update_n_lines = "sn", -- Update `n_lines`

        suffix_last = "p", -- Suffix to search with "prev" method
        suffix_next = "n", -- Suffix to search with "next" method
      },
    },
  },

  {
    "folke/noice.nvim",
    opts = {
      messages = {
        enabled = false,
      },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      event_handlers = {
        {
          event = "file_opened",
          handler = function(_)
            require("neo-tree.command").execute({ action = "close" })
          end,
        },
      },
    },
  },

  -- add symbols-outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>ts", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
  },

  {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    opts = {
      defaults = {
        layout_strategy = "vertical",
        layout_config = {
          prompt_position = "top",
          mirror = true,
        },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
    setup = function()
      require("telescope").load_extension("fzf")
    end,
  },

  -- since `vim.tbl_deep_extend`, can only merge tables and not lists, the code above
  -- would overwrite `ensure_installed` with the new value.
  -- If you'd rather extend the default config, use the code below instead:
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "tsx",
        "typescript",
        "go",
        "rust",
      })
    end,
  },

  {
    "google/vim-jsonnet",
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },

  -- Use <tab> for completion and snippets (supertab)
  -- first: disable default <tab> and <s-tab> behavior in LuaSnip
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    keys = function()
      return {}
    end,
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  -- then: setup supertab in cmp
  {
    "hrsh7th/nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      -- stylua: ignore
      require("cmp_nvim_lsp") .default_capabilities({
        textDocument = {
          completion = {
            completionItem = {
              snippetSupport = false,
            },
          },
        },
      })

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      opts.sources = cmp.config.sources({
        --{ name = "luasnip", max_item_count = 2 },
        {
          name = "nvim_lsp",
          entry_filter = function(entry)
            return cmp.lsp.CompletionItemKind.Snippet ~= entry:get_kind()
          end,
        },
      }, {
        { name = "luasnip" },
        { name = "copilot" },
        { name = "buffer" },
        { name = "path" },
      })

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-U>"] = cmp.mapping.scroll_docs(-4),
        ["<C-D>"] = cmp.mapping.scroll_docs(4),
        ["<C-N>"] = cmp.mapping.complete(),
        ["<C-L>"] = cmp.mapping.complete({
          config = {
            sources = {
              {
                name = "nvim_lsp",
                entry_filter = function(entry)
                  return cmp.lsp.CompletionItemKind.Snippet ~= entry:get_kind()
                end,
              },
            },
          },
        }),
        ["<C-B>"] = cmp.mapping.complete({
          config = {
            sources = {
              { name = "buffer" },
            },
          },
        }),
        ["<C-P>"] = cmp.mapping.complete({
          config = {
            sources = {
              { name = "path" },
            },
          },
        }),
        ["<C-S>"] = cmp.mapping.complete({
          config = {
            sources = {
              { name = "luasnip" },
            },
          },
        }),
        ["<C-C>"] = cmp.mapping.complete({
          config = {
            sources = {
              { name = "copilot" },
            },
          },
        }),
        --["<Tab>"] = cmp.mapping(function(fallback)
        --  if cmp.visible() then
        --    cmp.select_next_item()
        --    -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
        --    -- they way you will only jump inside the snippet region
        --  elseif luasnip.expand_or_jumpable() then
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
      })

      return opts
    end,
  },
}
