local logo = [[
  ██████   █████                   █████   █████  ███                  
 ░░██████ ░░███                   ░░███   ░░███  ░░░                   
  ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████   
  ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███  
  ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███  
  ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███  
  █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████ 
 ░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░  
]]

logo = string.rep("\n", 8) .. logo .. "\n\n"

return {
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
        filtered_items = {
          hide_dotfiles = true,
          hide_gitignored = false,
          hide_hidden = false, -- only works on Windows for hidden files/directories
        },
      },
    },
  },
  {
    "echasnovski/mini.indentscope",
    opts = {
      draw = {
        animation = function()
          return 0
        end,
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>ua",
        function()
          require("telescope").extensions.notify.notify()
        end,
        desc = "Display a log of the history",
      },
    },
    opts = {
      stages = "static",
      render = "wrapped-compact",
    },
  },
  -- Turn off sticky scroll
  {
    "nvim-treesitter/nvim-treesitter-context",
    enabled = false,
  },
  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        view = "cmdline",
      },
      presets = {
        command_palette = false,
        lsp_doc_border = true,
      },
    },
  },
  {
    "nvimdev/dashboard-nvim",
    opts = {
      config = {
        -- header = ascii.art.text.neovim.dos_rebel,
        header = vim.split(logo, "\n"),
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "powerline",
      },
      sections = {
        lualine_z = {
          { "encoding" },
          { "fileformat" },
        },
      },
      extensions = { "neo-tree", "lazy", "toggleterm" },
    },
  },
}
