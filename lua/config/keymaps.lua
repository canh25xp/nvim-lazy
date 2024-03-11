-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local nomap = vim.keymap.del

map("i", "jk", "<ESC>", { desc = "Escape insert mode" })

map("n", ";", ":", { desc = "CMD enter command mode" })
