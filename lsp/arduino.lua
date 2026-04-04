return {
  cmd = {
    "arduino-language-server",
    "-cli-config", vim.fn.expand(vim.g.is_windows and "~/AppData/Local/Arduino15/arduino-cli.yaml" or "~/.arduino15/arduino-cli.yaml"),
    "-fqbn", "arduino:avr:uno",
    "-cli", "arduino-cli",
    "-clangd", "clangd",
  },
}
