vim.pack.add({ { src = "https://github.com/zuqini/zpack.nvim" } })

require("zpack").setup({
  { import = "plugins" },
  defaults = {
    confirm = false,
  },
  performance = {
    vim_loader = true,
  },
})
