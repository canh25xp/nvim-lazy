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
        keys = {
          hide_slash = { "<C-\\>", "hide", desc = "Hide Terminal", mode = { "t", "n" } },
        },
      },
    },
    dashboard = {
      preset = {
        -- Override default keys Recent Files and Restore Session
        -- TODO: is there a better way to do this ? I don't want to redefine every keys
        -- stylua: ignore
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = ".", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "r", desc = "Restore Session", section = "session" },
          { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
    },
  },
}
