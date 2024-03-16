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
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<C-\>]],
        -- add --login so ~/.zprofile is loaded
        -- https://vi.stackexchange.com/questions/16019/neovim-terminal-not-reading-bash-profile/16021#16021
        -- shell = "bash --login",
      })
    end,
    cmd = "ToggleTerm",
    keys = {
      { [[<C-\>]] },
      { "<leader>0", "<Cmd>2ToggleTerm<Cr>", desc = "Terminal #2" },
    },
  },
  {
    "ellisonleao/glow.nvim",
    config = function()
      require("glow").setup({
        style = "dark",
        pager = false,
        border = "none",
      })
    end,
    cmd = "Glow",
  },
}
