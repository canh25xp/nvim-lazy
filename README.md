# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## Notes

### To rebuild spell file

- `:mkspell! spell/en.utf-8.add`

### To install plugins and exit

```bash
nvim --headless +qa
nvim --headless +MasonEnsureInstall +qa
```

> [!NOTE]
> I have NOT figure out a way to headlessly install mason packages and. Related discussions [Related discussions](https://github.com/LazyVim/LazyVim/discussions/3679)
> Update: `MasonEnsureInstall` command install mason packages headlessly but not packages added by LazyExtras.
