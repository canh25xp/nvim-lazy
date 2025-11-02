return {
  "snacks.nvim",
  opts = function(_, opts)
    opts.scroll = vim.tbl_deep_extend("force", opts.scroll or {}, {
      enabled = not vim.g.is_windows,
    })

    opts.styles = opts.styles or {}
    opts.styles.lazygit = vim.tbl_deep_extend("force", opts.styles.lazygit or {}, {
      height = 0,
      width = 0,
      border = "none",
    })

    opts.terminal = opts.terminal or {}
    opts.terminal.win = opts.terminal.win or {}
    opts.terminal.win.keys = vim.tbl_deep_extend("force", opts.terminal.win.keys or {}, {
      hide_slash = { "<C-\\>", "hide", desc = "Hide Terminal", mode = { "t", "n" } },
    })

    opts.dashboard = opts.dashboard or {}
    opts.dashboard.preset = opts.dashboard.preset or {}
    local keys = opts.dashboard.preset.keys
    if type(keys) ~= "table" then
      keys = {}
      opts.dashboard.preset.keys = keys
    end

    -- index, item
    for _, item in ipairs(keys) do
      if item.desc == "Recent Files" then
        item.key = "."
      elseif item.desc == "Restore Session" then
        item.key = "r"
      end
    end
  end,
}
