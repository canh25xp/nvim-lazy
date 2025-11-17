-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("i", "jk", "<ESC>", { desc = "Escape insert mode" })
map("n", "J", "mzJ`z", { desc = "Join without moving cursor" })
map("n", "<leader>//", [[/\<<C-r><C-w>\><cr>]], { desc = "Search word under cursor", silent = true })
map("n", "<leader>/s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Substitute word under cursor" })
map("n", "<leader>rc", [[<cmd>%s/\r//g|nohlsearch<CR>]], { desc = "Remove carriage return (^M)" }) -- ^M is <C-v><C-M>
map("n", "<leader>rw", [[<cmd>%s/\s\+$//e|nohlsearch<CR>]], { desc = "Remove trailing whitespaces" })

-- Yank, Paste and Delete
map("n", "<leader>Y", [["+Y]], { desc = "Yank to system clipboad" })
map("n", "<leader>P", [["+P]], { desc = "Paste from system clipboard" })
map("n", "<leader>p", [["+p]], { desc = "Paste from system clipboard" })
map("i", "<C-r><C-r>", [[<C-o>"+p]], { desc = "Paste form system clipboard" })
map("x", "<leader>p", [["_dP]], { desc = "Delete and Paste" })
map("n", "<leader>d", [["_d]], { desc = "Delete" })
map("n", "<leader>0", [["0p"]], { desc = "Paste last yank" })

pcall(vim.keymap.del, "n", "<leader>|")
map("n", "<leader>\\", "<C-w>v", { desc = "Split Window Right" })

-- Buffer
map("n", "<tab>", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

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
