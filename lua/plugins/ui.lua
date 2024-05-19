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

-- stylua: ignore
local colors = {
  blue   = '#89b4fa',
  cyan   = '#94e2d5',
  black  = '#45475a',
  white  = '#eff1f5',
  red    = '#f38ba8',
  violet = '#cba6f7',
  grey   = '#303446',
}

local catppuccin = {
  normal = {
    a = { fg = colors.black, bg = colors.violet },
    b = { fg = colors.white, bg = colors.grey },
    c = { fg = colors.white },
  },

  insert = {
    a = { fg = colors.black, bg = colors.blue },
  },
  visual = { a = { fg = colors.black, bg = colors.cyan } },
  replace = { a = { fg = colors.black, bg = colors.red } },

  inactive = {
    a = { fg = colors.white, bg = colors.black },
    b = { fg = colors.white, bg = colors.black },
    c = { fg = colors.white },
  },
}

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
        theme = catppuccin,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
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
