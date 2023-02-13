local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Lazy.nvim requires the leader to be set before loading:
vim.g.mapleader = " " -- Spacebar as leader

return require("lazy").setup({
  "nvim-lua/plenary.nvim",
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.0",
    dependencies = { { "nvim-lua/plenary.nvim" } },
    config = function()
      local project_actions = require "telescope._extensions.project.actions"
      require("telescope").setup {
        defaults = {
          layout_strategy = "vertical",
          sorting_strategy = "ascending",
          layout_config = {
            prompt_position = "top",
            vertical = {
              mirror = true,
            },
          },
          mappings = require("g/keybinds").telescope.defaults,
        },
        extensions = {
          project = {
            on_project_selected = function(prompt_bufnr)
              project_actions.change_working_directory(prompt_bufnr, false)
              -- TODO: this is broken if a session does not exist
              -- for the project because a buffer/file is never loaded.
              -- Need to check that a file has been loaded before doing
              -- the edit command.
              vim.cmd "e" -- make sure filetype is detected
            end,
          },
        },
      }
      require("telescope").load_extension "project"
    end,
  },

  {
    dir = "~/src/github.com/gerryhernandez/telescope-project.nvim",
    --"nvim-telescope/telescope-project.nvim",
  },

  {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup {
        log_level = "error",
        auto_session_suppress_dirs = { "/", "~/" },
        cwd_change_handling = {
          auto_session_root_dir = vim.fn.stdpath "data" .. "/sessions/",
          restore_upcoming_session = true,
          pre_cwd_changed_hook = function() end,
          post_cwd_changed_hook = function() -- example refreshing the lualine status line _after_ the cwd changes
          end,
        },
      }
      vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
    end,
  },

  {
    "ThePrimeagen/harpoon",
    config = function()
      require("harpoon").setup {}
    end,
  },

  -- Color Schemes:
  { "catppuccin/nvim", name = "catppuccin" },
  "Mofiqul/dracula.nvim",
  "folke/tokyonight.nvim",
  "marko-cerovac/material.nvim",
  "shaunsingh/moonlight.nvim",
  "yashguptaz/calvera-dark.nvim",
  "tiagovla/tokyodark.nvim",
  "kartikp10/noctis.nvim",

  -- Motion:
  "ggandor/leap.nvim",

  -- Status line:
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons", opt = true },
    config = function()
      require("lualine").setup()
    end,
  },

  -- File manager:
  {
    "kyazdani42/nvim-tree.lua",
    dependencies = {
      "kyazdani42/nvim-web-devicons", -- optional, for file icons
    },
    config = function()
      require("nvim-tree").setup {
        sync_root_with_cwd = true,
        on_attach = function(bufnr)
          require("g/keybinds").apply_nvim_tree(bufnr)
        end,
      }
    end,
  },

  -- Markdown Utils:
  -- install without yarn or npm
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },

  -- Obsidian notes integration:
  {
    dir = "~/src/github.com/gerryhernandez/obsidian.nvim",
    --"epwalsh/obsidian.nvim",
    config = function()
      require("obsidian").setup {
        use_advanced_uri = true,
        dir = "~/notes/Brain",
        daily_notes = {
          folder = "dailies",
        },
        completion = {
          nvim_cmp = true, -- if using nvim-cmp, otherwise set to false
        },
        note_id_func = function(title)
          return title
        end,
      }
    end,
  },

  --  use({
  --    'euclio/vim-markdown-composer',
  --    build = 'cargo build --release',
  --    config = function ()
  --      vim.g.markdown_composer_external_renderer='pandoc -f markdown -t html'
  --      vim.g.markdown_composer_autostart = 0
  --    end
  --  })

  -- Other niceties:

  -- Use NeoVim as a text editor for text fields within Firefox:
  {
    "glacambre/firenvim",
    build = function()
      vim.fn["firenvim#install"](0)
    end,
  },

  -- Shows available options for leader keys:
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {}
    end,
  },

  -- Auto pairs, as the name implies:
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {}
    end,
  },

  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
  -- use("tpope/vim-commentary")
  "tpope/vim-surround",
  "tpope/vim-repeat",

  "folke/trouble.nvim",

  -- Shows Git line status (changes, etc) in the gutter ("signs" column):
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Language Tools:

  {
    "nvim-treesitter/nvim-treesitter",
    -- commit = "fd4525fd9e61950520cea4737abc1800ad4aabb",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "c", "lua", "rust", "go", "markdown", "markdown_inline" },
        auto_install = true,
        highlight = {
          enable = true,
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
        },
      }
    end,
  },
  "neovim/nvim-lspconfig",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp-signature-help",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",
  "williamboman/mason-lspconfig.nvim",
  -- use({'jayp0521/mason-nvim-DAP, etc:
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
      -- require("mason-nvim-dap").setup({
      --   automatic_setup = true,
      --   automatic_installation = true,
      --   ensure_installed = {'delve'}
      -- })
    end,
  },

  -- Debugging
  "mfussenegger/nvim-dap",
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dapui").setup()
    end,
  },
  {
    "leoluz/nvim-dap-go",
    config = function()
      require("dap-go").setup()
    end,
  },
})
