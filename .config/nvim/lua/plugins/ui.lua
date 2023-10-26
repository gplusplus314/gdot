return {
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
      pickers = {
        live_grep = {
          mappings = {
            i = { ["<c-f>"] = require("telescope.actions").to_fuzzy_refine },
          },
        },
      },
    },
  },

  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
}
