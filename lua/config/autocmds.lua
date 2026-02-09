-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = "*.tmpl",
  callback = function()
    vim.api.nvim_create_user_command("TmplPreview", function()
      local file = vim.api.nvim_buf_get_name(0)

      if file == "" then
        print("No file name detected.")
        return
      end

      local watch_cmd = string.format([[clear; chezmoi execute-template -f %s]], file)
      local cmd = string.format([[bash -c 'ls %s | entr -r sh -c "%s"']], file, watch_cmd)

      print(cmd)

      vim.cmd("vsplit | terminal " .. cmd)
    end, { desc = "Watch and Execute current chezmoi template" })
    vim.keymap.set("n", "<leader>ce", "<cmd>TmplPreview<cr>", { desc = "Chezmoi execute template" })
  end,
  desc = "Auto-update chezmoi template output",
})
