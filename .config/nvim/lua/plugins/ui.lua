local is_full_nvim = _G.config_mode == "nvim"
return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        layout = {
          layout = {
            backdrop = false,
            width = 0.9,
            min_width = 80,
            height = 0.9,
            min_height = 30,
            box = "vertical",
            border = "rounded",
            title = "{title} {live} {flags}",
            title_pos = "center",
            { win = "input", height = 1, border = "bottom" },
            { win = "list", border = "none" },
            { win = "preview", title = "{preview}", height = 0.6, border = "top" },
          },
        },
  -- stylua: ignore
        win = {
          -- input window
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "n", "i" } },
              ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<c-f>"] = { "list_scroll_down", mode = { "i", "n" } },
              ["<c-b>"] = { "list_scroll_up", mode = { "i", "n" } },
              ["<c-/>"] = { "toggle_help_input", mode = { "i", "n" } },
            },
            b = {
              minipairs_disable = true,
            },
          },
          -- result list window
          -- preview window
        },
      },
    },
  -- stylua: ignore
    keys = function() return {
      { "<leader><leader>", function() Snacks.picker.buffers() end, desc = "Buffers" },
      -- git
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "git [d]iff" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "git [s]tatus" },
      { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "git [S]tash" },
      -- search
      { "<leader>s:", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>sn", function() Snacks.picker.notifications() end, desc = "Notification History" },
      { "<leader>sb", function() Snacks.picker.buffers() end, desc = "[B]uffers" },
      --{ "<leader>sB", function() Snacks.picker.buffers({ hidden = true, nofile = true }) end, desc = "[B]uffers (all)" },
      { "<leader>sc", LazyVim.pick.config_files(), desc = "[c]onfig file" },
      { "<leader>sf", LazyVim.pick("files"), desc = "[f]iles (Root Dir)" },
      { "<leader>sF", LazyVim.pick("files", { root = false }), desc = "[F]iles (cwd)" },
      { "<leader>sv", function() Snacks.picker.git_files() end, desc = "[v]cs (git-files)" },
      { "<leader>sr", LazyVim.pick("oldfiles"), desc = "[r]ecent files" },
      --{ "<leader>sR", function() Snacks.picker.recent({ filter = { cwd = true }}) end, desc = "[r]ecent (cwd)" },
      --{ "<leader>sp", function() Snacks.picker.projects() end, desc = "[p]rojects" },
      { "<leader>s/", function() Snacks.picker.lines() end, desc = "buffer lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "open [B]uffers lines" },
      { "<leader>sg", function() Snacks.picker.grep({
            need_search = false,
            live = false,
          })
      end, desc = "fuzzy [g]rep (Root Dir)" },
      { "<leader>sG", function() Snacks.picker.grep({
            need_search = false,
            live = false,
            root = false,
          })
      end, desc = "fuzzy [g]rep (cwd)" },
      { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
      { "<leader>sw", LazyVim.pick("grep_word"), desc = "Visual selection or word (Root Dir)", mode = { "n", "x" } },
      { "<leader>sW", LazyVim.pick("grep_word", { root = false }), desc = "Visual selection or word (cwd)", mode = { "n", "x" } },
      { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
      --{ '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
      { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "[a]utocmds" },
      { "<leader>sc", function() Snacks.picker.command_history() end, desc = "[c]ommand history" },
      { "<leader>sC", function() Snacks.picker.commands() end, desc = "[C]ommands" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "[d]iagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "buffer [D]iagnostics" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "[h]elp pages" },
      { "<leader>sH", function() Snacks.picker.highlights() end, desc = "[H]ighlights" },
      { "<leader>si", function() Snacks.picker.icons() end, desc = "[i]cons" },
      { "<leader>sj", function() Snacks.picker.jumps() end, desc = "[j]umps" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "[k]eymaps" },
      { "<leader>sL", function() Snacks.picker.loclist() end, desc = "[L]ocation list" },
      { "<leader>sM", function() Snacks.picker.man() end, desc = "[M]an pages" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "[m]arks" },
      { "<leader>sR", function() Snacks.picker.resume() end, desc = "[R]esume" },
      { "<leader>sq", function() Snacks.picker.qflist() end, desc = "[q]uickfix list" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "[u]ndotree" },
      -- ui
      { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "[C]olorschemes" },
    } end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
    },
  },

  {
    "akinsho/bufferline.nvim",
    lazy = false,
    opts = {
      options = {
        always_show_bufferline = true,
      },
    },
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
