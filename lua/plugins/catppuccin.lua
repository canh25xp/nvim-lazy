return {
  "catppuccin/nvim",
  keys = {
    {
      "<leader>ut",
      function()
        -- TODO: refactor Snacks.toggle()
        local cat = require("catppuccin")
        cat.options.transparent_background = not cat.options.transparent_background
        cat.compile()
        vim.cmd.colorscheme(vim.g.colors_name)
      end,
      desc = "Toggle Transparency",
    },
  },
  opts = {
    compile_path = vim.fn.stdpath("config") .. "/.catppuccin",
  },
}
