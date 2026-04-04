-- ~/.local/share/nvim/lazy/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" }, -- Import all plugins in the plugins folder
    -- { import = "plugins.catppuccin" },
    -- { import = "plugins.treesitter" },
    -- { import = "plugins.neo-tree" },
    -- { import = "plugins.lsp" },
    -- { import = "plugins.cmp" },
    -- { import = "plugins.luaSnip" },
    -- { import = "plugins.conform" },
    -- { import = "plugins.dap" },
    -- { import = "plugins.noice" },
    -- { import = "plugins.lualine" },
    -- { import = "plugins.dashboard" },
    -- { import = "plugins.persistance" },
    -- { import = "plugins.bufferline" },
    -- { import = "plugins.autopairs" },
    -- { import = "plugins.cmake-tools" },
    -- { import = "plugins.fzf" },
    -- { import = "plugins.gitsigns" },
    -- { import = "plugins.mini" },
    -- { import = "plugins.telescope" },
    -- { import = "plugins.toggleterm" },
    -- { import = "plugins.vim-sleuth" },
    -- { import = "plugins.vimtex" },
    -- { import = "plugins.chezmoi" },
    -- { import = "plugins.lint" },
    -- { import = "plugins.todo-comments" },
    -- { import = "plugins.url-open" },
    -- { import = "plugins.which-key" },
    -- { import = "plugins.flatten" },
    -- { import = "plugins.peek" },
  },
  lockfile = vim.fn.stdpath("config") .. "/.lazy-lock.json",
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "catppuccin", "habamax" } },
  checker = {
    enabled = false, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  ui = {
    size = {
      width = 0.9,
      height = 0.9,
    },
  },
  custom_keys = {
    ["<localleader>l"] = {
      function(plugin)
        require("lazy.util").float_term({ "lazygit", "log" }, {
          cwd = plugin.dir,
        })
      end,
      desc = "Open lazygit log",
    },

    ["<localleader>t"] = {
      function(plugin)
        require("lazy.util").float_term(nil, {
          cwd = plugin.dir,
        })
      end,
      desc = "Open terminal in plugin dir",
    },

    ["<localleader>o"] = {
      function(plugin)
        -- TODO: this worth refactor as a function
        local app = vim.g.is_windows and "start" or "xdg-open"
        local url = plugin.url
        local command = app .. " " .. vim.fn.shellescape(url)
        vim.fn.jobstart(command, {
          detach = not vim.g.is_windows,
          on_exit = function(_, code, _)
            if code ~= 0 then
              require("url-open.modules.logger").error("Failed to open " .. url)
            else
              require("url-open.modules.logger").info("Opening " .. url)
            end
          end,
        })
      end,
      desc = "Open plugins in the explorer",
    },
  },
  dev = {
    fallback = true,
    path = "~/projects/lua",
    -- pattern = {
    --   "LazyVim",
    -- },
  },
  rocks = {
    enabled = false,
  },
})
