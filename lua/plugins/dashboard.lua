local ascii = require("ascii")
return {
  "nvimdev/dashboard-nvim",
  opts = {
    config = {
      header = ascii.art.text.neovim.sharp,
    },
  },
}
