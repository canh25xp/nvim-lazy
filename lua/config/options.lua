-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
local g = vim.g
local o = vim.o

g.maplocalleader = "\\"
g.autoformat = false
g.root_spec = { "cwd" }

opt.linebreak = true
opt.timeoutlen = 500
opt.relativenumber = true
opt.cursorlineopt = "number"
opt.conceallevel = 0
opt.wildmode = "list:full" -- Command-line completion mode
opt.smoothscroll = false

-- Set shell to PowerShell 7 if on Win32 or Win64
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  opt.shell = "pwsh"
  opt.shellcmdflag =
    "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
  opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
  opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  opt.shellquote = ""
  opt.shellxquote = ""
end

if g.neovide then
  o.guifont = "Hack Nerd Font:h12"
  g.neovide_fullscreen = true
  g.neovide_scroll_animation_length = 0.3
  g.neovide_cursor_vfx_mode = "railgun"
end
