return {
  {
    "folke/flash.nvim",
    enabled = false,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      -- default_component_configs = {
      --   git_status = {
      --     symbols = false
      --   }
      -- },
      close_if_last_window = true,
      window = {
        mappings = {
          ["l"] = "open",
          ["."] = "toggle_hidden",
          ["P"] = { "toggle_preview", config = { use_float = false, use_image_nvim = false} },
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
