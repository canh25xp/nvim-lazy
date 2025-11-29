return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      ps1 = { "pwsh_formatter" },
    },
    formatters = {
      pwsh_formatter = {
        command = vim.o.shell,
        args = {
          "-NoProfile",
          "-Command",
          "Edit-DTWBeautifyScript",
          "$FILENAME",
        },
        stdin = false,
      },
    },
  },
}
