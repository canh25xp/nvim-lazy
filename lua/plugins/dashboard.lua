return {
  "snacks.nvim",
  opts = function(_, opts)
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
