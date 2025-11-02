-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local ci_selector = require("common.ci_selector")

map("i", "jk", "<ESC>", { desc = "Escape insert mode" })
-- map("n", ";", ":", { desc = "CMD enter command mode" })
-- map("n", "q;", "q:", { desc = "CMD history" })

-- Buffer
map("n", "<tab>", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- BUG: Snacks is not yet available when lazy.nvim first install, causing field not found on first time neovim open.
-- Terminal
pcall(vim.keymap.del, { "n", "t" }, "<C-/>")
pcall(vim.keymap.del, { "n", "t" }, "<C-_>")
map({ "n", "t" }, "<c-\\>", function() Snacks.terminal(nil, { cwd = LazyVim.root() }) end, { desc = "Terminal Toggle" })
map("n", "<leader>tt", function() Snacks.terminal(nil, { cwd = LazyVim.root(), win = { position = "float", width = 0, height = 0, border = "none" } }) end, { desc = "Terminal Fullscreen" })
map("n", "<leader>bt", function() Snacks.terminal({ "btm" }, { win = { style = "lazygit" } }) end, { desc = "Bottom" })
map("n", "<leader>ci", function() ci_selector.ci() end, { desc = "Code Intelligent" })

-- Lazy
pcall(vim.keymap.del, "n", "<leader>l")
map("n", "<leader>lz", "<cmd>Lazy<cr>", { desc = "Lazy" })
map("n", "<leader>le", "<cmd>LazyExtras<cr>", { desc = "Lazy" })

if vim.g.vscode then
  -- Load nvim vscode specific key bindings
  local vscode = require("vscode")
  vim.keymap.set("n", "<leader>cf", function()
    vscode.action("editor.action.formatDocument")
  end)

  vim.keymap.set("n", "<leader>gg", function()
    vscode.action("workbench.view.scm")
  end)

  vim.keymap.set("n", "<leader>e", function()
    vscode.action("workbench.view.explorer")
  end)

  vim.keymap.set("n", "<leader>E", function()
    vscode.action("workbench.files.action.showActiveFileInExplorer")
  end)

  vim.keymap.set("n", "<leader>j", function()
    vscode.action("workbench.action.togglePanel")
  end)
end
