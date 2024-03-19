return {
  {
    "MaximilianLloyd/ascii.nvim",
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
      open_mapping = [[<c-\>]],
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
    config = {
      style = "dark",
      pager = false,
      border = "shadow",
    },
    cmd = "Glow",
  },
}
