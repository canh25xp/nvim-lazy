return {
  "folke/lazydev.nvim",
  enabled = true,
  version = false,
  ft = "lua",
  dependencies = "Bilal2453/luvit-meta",
  opts = {
    library = {
      { path = "luvit-meta/library", words = { "vim%.uv" } },
      { path = "snacks.nvim", words = { "Snacks" } },
    },
  },
}
