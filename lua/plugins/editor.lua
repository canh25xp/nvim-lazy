return {
  {
    "folke/flash.nvim",
    enabled = false
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      close_if_last_window = true,
      window = {
        mappings = {
          ["l"] = "open",
        },
      },
      filesystem = {
        bind_to_cwd = true,
        filtered_items = {
          hide_dotfiles = true,
          hide_gitignored = false,
          hide_hidden = false, -- only works on Windows for hidden files/directories
        },
      },
    },
  },
}
