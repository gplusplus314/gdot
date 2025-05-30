local is_freebsd = vim.loop.os_uname().sysname == "FreeBSD"
if not is_freebsd then
  return {}
end

return {
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
    lazy = false,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.tbl_filter(function(name)
        return not vim.tbl_contains({ "shfmt", "stylua" }, name)
      end, opts.ensure_installed)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          mason = false,
        },
        taplo = {
          mason = false,
        },
        buf_ls = {
          mason = false,
        },
      },
    },
  },
}
