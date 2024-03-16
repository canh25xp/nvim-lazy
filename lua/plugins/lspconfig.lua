return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        -- pyright = {},
        html = {},
        emmet_ls = {},
        emmet_language_server = {},
        -- yamlls = {},
      },
    },
  },
}
