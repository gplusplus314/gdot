local is_freebsd = vim.loop.os_uname().sysname == "FreeBSD"
if not is_freebsd then
  return {}
end

return {
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
