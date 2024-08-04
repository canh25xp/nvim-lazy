return {
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      -- { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
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
      enabled = false,
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
      shade_terminals = false,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      close_on_exit = true,
    },
    cmd = "ToggleTerm",
    keys = {
      { [[<C-\>]] },
      { "<leader>0", "<Cmd>2ToggleTerm<Cr>", desc = "Terminal #2" },
      { "<leader>t", "<Cmd>ToggleTerm direction=tab<Cr>", desc = "Terminal in new tab" },
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
  -- markdown preview
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    keys = {
      {
        "<leader>cp",
        ft = "markdown",
        function()
          local peek = require("peek")
          if peek.is_open() then
            peek.close()
          else
            peek.open()
          end
        end,
        desc = "Peek (Markdown Preview)",
      },
    },
    opts = {
      theme = "dark",
      app = "browser",
      close_on_bdelete = false,
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    enabled = false,
  },
}
