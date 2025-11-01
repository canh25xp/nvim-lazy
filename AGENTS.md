# Repository Guidelines

## Project Structure & Module Organization
Neovim loads from `init.lua`, which bootstraps LazyVim through `lua/config/lazy.lua`. Runtime settings live in `lua/config` (`options.lua`, `keymaps.lua`, `autocmds.lua`), while feature work happens in `lua/plugins`, where each file returns a Lazy spec table. Shared utilities should go under `lua/common` (for example, the CI selector helper). Spell additions belong in the `spell/` directory, and any Lazy extras toggles should be declared in `lazyvim.json`.

## Build, Test, and Development Commands
- `nvim --headless "+Lazy! sync" +qa` – install or update plugins defined in the specs.
- `nvim --headless "+MasonInstall clangd clang-format" +qa` – prefetch language servers/tools when updating language extras.
- `nvim --headless "+checkhealth" +qa` – run Neovim health checks after changing core settings.
During interactive development, prefer `:Lazy`, `:LazyExtras`, and `:Mason` inside Neovim to verify module wiring.

## Coding Style & Naming Conventions
Lua files use two-space indentation and UTF-8. Export module tables via `return { … }` and name plugin spec files after the feature (`arduino.lua`, `nvim-lint.lua`). Keep option overrides idempotent; guard platform-specific tweaks with the `vim.g.is_*` flags defined in `init.lua`. Use descriptive keys in dashboard/snacks configurations and keep anonymous callbacks short—extract helpers into `lua/common` when logic grows. Run `stylua` before committing (`stylua lua`).

## Testing Guidelines
There is no automated test suite, so validate changes by launching Neovim with `nvim --clean --cmd "lua require('config.lazy')"`. Confirm key mappings via `:Telescope keymaps` and lint integrations with `:NullLsInfo` or `:Mason`. When editing language extras, open representative files for Lua, TypeScript, Go, and Markdown to ensure tree-sitter, LSP, and lint hooks load without errors. Record any regressions or required follow-up in the PR description.

## Commit & Pull Request Guidelines
Follow the existing log style: `<area>: short imperative summary` (e.g., `nvim-lint: relax markdown rules`). Group related spec edits in a single commit and reference affected plugin files in the body. PRs should explain rationale, list manual verification steps (`Lazy sync`, `checkhealth`, sample buffers), and link issues if applicable. Include screenshots or ASCII output when UI tweaks change dashboards or color schemes.

## Agent-Specific Tips
Since this config is based on the `LazyVim` distribution, most configurations is made by lazyvim, so you should always look into the LazyVim directory at `~/.local/share/nvim-lazy/lazy/LazyVim/lua/lazyvim` for references.
