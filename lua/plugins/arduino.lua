return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        arduino_language_server = {
          cmd = {
            "arduino-language-server",
            "-cli-config", vim.fn.expand("~/Appdata/Local/Arduino15/arduino-cli.yaml"),
            "-fqbn", "arduino:avr:uno",
            "-cli", "arduino-cli",
            "-clangd", "clangd",
          },
        },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "arduino-language-server",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "arduino" })
      end
    end,
  },
}
