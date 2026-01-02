local ci_selector = require("common.ci_selector")

local logo = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
]]

return {
  "snacks.nvim",
  opts = {
    scroll = {
      enabled = not vim.g.is_windows,
    },
    styles = {
      lazygit = {
        height = 0,
        width = 0,
        border = "none",
      },
    },
    terminal = {
      win = {
        wo = {
          winbar = "",
        },
        keys = {
          hide_slash = { "<C-\\>", "hide", desc = "Hide Terminal", mode = { "t", "n" } },
        },
      },
    },
    dashboard = {
      preset = {
        header = logo,
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = ".", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "r", desc = "Restore Session", section = "session" },
          { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
    },
    picker = {
      sources = {
        files = {
          layout = {
            fullscreen = true,
          },
        },
        grep = {
          layout = {
            fullscreen = true,
          },
        },
      },
    },
  },
  -- stylua: ignore
  keys = {
    { "<C-\\>",       function() Snacks.terminal() end, desc = "Toggle Terminal" },
    { "<leader>tt",   function() Snacks.terminal(nil, { cwd = LazyVim.root(), win = { position = "float", width = 0, height = 0, border = "none" } }) end, desc = "Terminal Fullscreen" },
    { "<leader>lf",   function() Snacks.terminal({ "lf" }, { win = { style = "lazygit" } }) end, desc = "List Files" },
    { "<leader>ya",   function() Snacks.terminal({ "yazi" }, { win = { style = "lazygit" } }) end, desc = "Yazi" },
    { "<leader>bt",   function() Snacks.terminal({ "btm" }, { win = { style = "lazygit" } }) end, desc = "Bottom" },
    { "<leader>ci",   function() ci_selector.ci() end, desc = "Code Intelligent" }
  },
}
