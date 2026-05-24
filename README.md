# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## Notes

### To rebuild spell file

- `:mkspell! spell/en.utf-8.add`

### To install plugins and exit

If you are setting up your configuration on a new machine or in a CI environment, you can run Neovim headlessly to trigger the native `vim.pack.add` installation for all active plugins and exit immediately:

```bash
nvim --headless +q
```
