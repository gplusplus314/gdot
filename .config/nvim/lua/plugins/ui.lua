local is_full_nvim = _G.config_mode == "nvim"
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
    },
  },

  {
    "akinsho/bufferline.nvim",
    lazy = false,
    event = function()
      return {}
    end,
  },
  {
    "folke/persistence.nvim",
    cond = is_full_nvim,
    lazy = false,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    cond = is_full_nvim,
    lazy = false,
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
    "folke/noice.nvim",
    opts = {
      messages = {
        enabled = false,
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

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      transparent_background = not is_full_nvim,
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
}
