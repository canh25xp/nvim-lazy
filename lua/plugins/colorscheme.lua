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
      style = "night",
      transparent = false,
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
      transparent_background = false,
      background = {
        light = "latte",
        dark = "mocha",
      },
      show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
      -- color_overrides = {
      --   mocha = {
      --     text = "#F4CDE9",
      --     subtext1 = "#DEBAD4",
      --     subtext0 = "#C8A6BE",
      --     overlay2 = "#B293A8",
      --     overlay1 = "#9C7F92",
      --     overlay0 = "#866C7D",
      --     surface2 = "#705867",
      --     surface1 = "#5A4551",
      --     surface0 = "#44313B",
      --     base = "#352939",
      --     mantle = "#211924",
      --     crust = "#1a1016",
      --   },
      -- },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
