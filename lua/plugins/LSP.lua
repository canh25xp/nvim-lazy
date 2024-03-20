return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      servers = {
        html = {
          filetypes = {
            "html",
            "templ",
            "htmldjango",
          },
        },
        emmet_ls = {},
      },
    },
  },
}
