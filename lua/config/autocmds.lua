-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local api = vim.api

api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

api.nvim_create_autocmd("TermOpen", {command = "setlocal nonu nornu signcolumn=no"})
