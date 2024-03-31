local theme = ""
if vim.g.neovide then
  theme = "catppuccin"
else
  theme = "tokyonight"
end

return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "storm",
      transparent = true,
      dim_inactive = true,
      terminal_colors = true,
      styles = {
        sidebars = "dark", -- style for sidebars, see below
        floats = "dark", -- style for floating windows
      },
    },
  },
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      transparent_background = false, -- disables setting the background color.
      dim_inactive = {
        enabled = true, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.5, -- percentage of the shade to apply to the inactive window
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = theme,
    },
  },
}
