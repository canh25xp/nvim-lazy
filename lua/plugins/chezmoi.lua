return {
  {
    "xvzc/chezmoi.nvim",
    opts = {
      edit = {
        watch = false,
        force = true,
        ignore_patterns = {
          "run_onchange_.*",
          "run_once_.*",
          "%.chezmoiignore",
          "%.chezmoitemplate",
          "%.lua",
          "%.md",
        },
      },
    },
    init = function()
      local home = vim.env.HOME
      if not home or home == "" then
        return
      end

      local function normalize(path)
        return (path or ""):gsub("\\", "/")
      end

      local root = normalize(home .. "/.local/share/chezmoi")
      if not (vim.uv or vim.loop).fs_stat(root) then
        return
      end

      local group = vim.api.nvim_create_augroup("ChezmoiEditWatcher", { clear = true })
      local excluded = {
        root .. "/nvim/",
        root .. "/nvim-lazy/",
      }

      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        group = group,
        pattern = { root .. "/**" },
        callback = function(args)
          local file = normalize(args.match)
          for _, skip in ipairs(excluded) do
            if vim.startswith(file, skip) then
              return
            end
          end
          vim.schedule(require("chezmoi.commands.__edit").watch)
        end,
      })
    end,
  },
}
