return {
  {
    "MaximilianLloyd/ascii.nvim",
    enabled = false,
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
  },
  {
    {
      "princejoogie/chafa.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "m00qek/baleia.nvim",
      },
      config = function()
        require("chafa").setup({
          render = {
            min_padding = 5,
            show_label = true,
          },
          events = {
            update_on_nvim_resize = true,
          },
        })
      end,
    },
  },
  {
    "akinsho/toggleterm.nvim",
    opts = {
      size = 20,
      open_mapping = [[<C-\>]],
      hide_numbers = true,
      shade_terminals = true,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      close_on_exit = true,
    },
    cmd = "ToggleTerm",
    keys = {
      { [[<C-\>]] },
      { "<leader>0", "<Cmd>2ToggleTerm<Cr>", desc = "Terminal #2" },
    },
  },
  -- Preview and render Markdown directly in the terminal
  {
    "ellisonleao/glow.nvim",
    opts = {
      style = "dark",
      pager = false,
      border = "none",
    },
    cmd = "Glow",
  },
  {
    "chrisbra/unicode.vim",
    cmd = {
      "UnicodeName",
      "UnicodeSearch",
      "Digraphs",
    },
  },
  {
    "norcalli/nvim-colorizer.lua",
    cmd = {
      "ColorizerToggle",
    },
  },
  {
    "alker0/chezmoi.vim",
    lazy = false,
    init = function()
      -- This option is required.
      vim.g["chezmoi#use_tmp_buffer"] = true
      -- add other options here if needed.
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = {
        disable = function()
          -- check if 'filetype' option includes 'chezmoitmpl'
          if string.find(vim.bo.filetype, "chezmoitmpl") then
            return true
          end
        end,
      },
    },
  },
}
