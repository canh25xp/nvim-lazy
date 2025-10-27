vim.g.is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
vim.g.is_linux = vim.fn.has("unix") == 1
vim.g.is_android = vim.fn.has("android") == 1
vim.g.is_wsl = vim.fn.has("wsl") == 1
vim.g.is_mac = vim.fn.has("mac") == 1
vim.g.path_sep = vim.g.is_windows and ";" or ":"

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
