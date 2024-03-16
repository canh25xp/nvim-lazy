if not vim.g.vscode then
  -- bootstrap lazy.nvim, LazyVim and your plugins
  require("config.lazy")
else
  print("neovim-vscode config")
end
