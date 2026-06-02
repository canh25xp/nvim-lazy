# Nvim mini

## Install

```sh
git clone https://github.com/canh25xp/nvim -b minimal ~/.config/nvim-mini
export NVIM_APPNAME=nvim-mini
```

## Notes

### To rebuild spell file

- `:mkspell! spell/en.utf-8.add`

### To install plugins and exit

If you are setting up your configuration on a new machine or in a CI environment, you can run Neovim headlessly to trigger the native `vim.pack.add` installation for all active plugins and exit immediately:

```bash
nvim --headless +q
```

### To install `Mason` packages and exit

```bash
nvim --headless +MasonEnsureInstall +q
```

### Trust `.nvim.lua` file

```bash
nvim --headless .nvim.lua +trust +q
```

### Get help from cli

```bash
nvim --headless --noplugin "+help pack.txt" "+%print" +qa!
```

### Pack commands

Plugin management helpers (wrap native `vim.pack`):

| Command | Description |
|---------|-------------|
| `:PackAdd {user/repo}` | Install and load a plugin (does not create `lua/plugins/` specs) |
| `:PackRemove {name}` | Delete a plugin from disk |
| `:PackRestore [name]` | Restore to `nvim-pack-lock.json` (all plugins if no name) |
| `:PackUpgrade [name]` | Update plugins (all if no name) |
| `:PackList` | List installed plugins, revisions, and paths |
| `:PackClean` | Remove plugins not declared in `lua/plugins/` |
| `:PackNuke!` | Delete all vim.pack-managed plugins (requires `!`) |

Append `!` to skip the confirmation buffer on restore/upgrade, e.g. `:PackUpgrade! snacks.nvim`.

## References

- [Migrating from lazy.nvim to vim.pack](https://yeripratama.com/blog/migrating-from-lazynvim-to-vimpack/)
- [From lazy.nvim to vim.pack](https://fredrikaverpil.github.io/blog/2026/04/15/from-lazy.nvim-to-vim.pack/#what-can-vimpack-do-out-of-the-box)
- [zpack - thin layer over native 'vim.pack`, adding support for lazy-loading and lazy.nvim specs](https://github.com/zuqini/zpack.nvim)
