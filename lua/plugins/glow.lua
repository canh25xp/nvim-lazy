return {
  {
    "ellisonleao/glow.nvim",
    config = function()
      require("glow").setup({
        style = "dark",
        pager = false,
        border = "none",
      })
    end,
    cmd = "Glow",
  },
}
