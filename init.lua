vim.g.mapleader = " " --  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.maplocalleader = "\\"
vim.g.have_nerd_font = true
vim.g.dynamic_cmdheight = true
vim.g.is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
vim.g.is_linux = vim.fn.has("unix") == 1
vim.g.is_android = vim.fn.has("android") == 1
vim.g.is_wsl = vim.fn.has("wsl") == 1
vim.g.is_mac = vim.fn.has("mac") == 1
vim.g.path_sep = vim.g.is_windows and ";" or ":"
vim.g.is_headless = #vim.api.nvim_list_uis() == 0

vim.g.loaded_perl_provider = 0 -- Disable perl provider
vim.g.loaded_ruby_provider = 0 -- Disable ruby provider
vim.g.loaded_node_provider = 0 -- Disable node provider
vim.g.loaded_python3_provider = 0 -- Disable python provider

require("config.options")
require("config.keymaps")
require("config.autocmds")
if vim.fn.has("nvim-0.12") == 1 then
  require("config.pack")
else
  require("config.lazy")
end
require("config.usercommands")
require("config.lsp")
