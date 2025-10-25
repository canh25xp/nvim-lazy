return {
  "snacks.nvim",
  opts = {
    styles = {
      lazygit = {
        height = 0,
        width = 0,
        border = "none",
      },
    },
    terminal = {
      win = {
        keys = {
          hide_slash = { "<C-\\>", "hide", desc = "Hide Terminal", mode = { "t", "n" } },
        },
      },
    },
  },
}
