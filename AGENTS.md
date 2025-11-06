# Repository Guidelines

## Project Structure & Module Organization

Neovim loads from `init.lua`, which bootstraps LazyVim through `lua/config/lazy.lua`. Runtime settings live in `lua/config` (`options.lua`, `keymaps.lua`, `autocmds.lua`), while feature work happens in `lua/plugins`, where each file returns a Lazy spec table. Shared utilities should go under `lua/common` (for example, the CI selector helper). Spell additions belong in the `spell/` directory, and any Lazy extras toggles should be declared in `lazyvim.json`.

## Coding Style & Naming Conventions

Lua files use two-space indentation and UTF-8. Export module tables via `return { … }` and name plugin spec files after the feature (`arduino.lua`, `nvim-lint.lua`). Keep option overrides idempotent; guard platform-specific tweaks with the `vim.g.is_*` flags defined in `init.lua`. Use descriptive keys in dashboard/snacks configurations and keep anonymous callbacks short—extract helpers into `lua/common` when logic grows. Run `stylua` before committing (`stylua lua`).

## Commit & Pull Request Guidelines

Follow the existing log style: `<area>: short imperative summary` (e.g., `nvim-lint: relax markdown rules`). Group related spec edits in a single commit and reference affected plugin files in the body. PRs should explain rationale, list manual verification steps (`Lazy sync`, `checkhealth`, sample buffers), and link issues if applicable. Include screenshots or ASCII output when UI tweaks change dashboards or color schemes.

## Agent-Specific Tips

Since this config is based on the `LazyVim` distribution, most configurations is made by LazyVim, so you should always look into the LazyVim directory:

- `~/.local/share/nvim-lazy/lazy/LazyVim/lua/lazyvim` for references.

If you want to search a specific documents for a plugin, look in to this directory:

- `~/.local/share/nvim-lazy/lazy/plugin-name/doc/"`
