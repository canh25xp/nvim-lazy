return {
  "willothy/flatten.nvim",
  enabled = false,
  -- Ensure that it runs first to minimize delay when opening file from terminal
  lazy = false,
  priority = 1001,
  opts = {
    window = {
      open = "alternate",
      diff = "tab_vsplit",
      focus = "first",
    },
  },
}
