-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local nomap = vim.keymap.del
local util = require("lazyvim.util")

local function toggle_term()
  local opts = {
    size = { width = 1, height = 1 },
  }
  util.terminal(nil, opts)
end

local function lazygit()
  util.terminal({ "lazygit" }, {
    size = {
      width = 1,
      height = 1,
    },
    cwd = util.root(),
    esc_esc = false,
    ctrl_hjkl = false,
  })
end

map("n", "<leader>gg", lazygit, { desc = "Lazygit (root dir)" })

-- Auto translate to <C-/>
map("n", "<C-_>", toggle_term, { desc = "Terminal (root dir )" })

map("i", "jk", "<ESC>", { desc = "Escape insert mode" })

map("n", ";", ":", { desc = "CMD enter command mode" })

map("n", "q;", "q:", { desc = "CMD history" })

map("n", "<tab>", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- map("n", "<C-b>", "<cmd>colorscheme habamax<cr>", { desc = "" })

-- map("n", "<C-b>", "<leader>fe", { desc = "Explorer NeoTree (root dir)", remap = true })

-- map("n", "<leader>d", "<leader>bd", { desc = "Delete Buffer", remap = true })

map("n", "<leader>/", "gcc", { desc = "Comment line", remap = true })
