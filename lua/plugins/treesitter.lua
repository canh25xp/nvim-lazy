local function list_contains(list, value)
  if type(list) ~= "table" then
    return false
  end
  return vim.tbl_contains(list, value)
end

local function is_feature_enabled(feature_opts, lang, bufnr)
  if type(feature_opts) ~= "table" then
    return false
  end

  local enable = feature_opts.enable
  local enabled = false

  if type(enable) == "boolean" then
    enabled = enable
  elseif type(enable) == "table" then
    enabled = list_contains(enable, lang)
  elseif type(enable) == "function" then
    enabled = enable(lang, bufnr)
  end

  if not enabled then
    return false
  end

  local disable = feature_opts.disable
  if type(disable) == "boolean" then
    return not disable
  elseif type(disable) == "table" then
    return not list_contains(disable, lang)
  elseif type(disable) == "function" then
    return not disable(lang, bufnr)
  end

  return true
end

return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "arduino",
      "bash",
      "bibtex",
      "c",
      "cmake",
      "cpp",
      "diff",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      "groovy",
      "html",
      "ini",
      "java",
      "javascript",
      "json",
      "json5",
      "kotlin",
      "lua",
      "luadoc",
      "make",
      "markdown",
      "markdown_inline",
      "powershell",
      "properties",
      "python",
      "query",
      "readline",
      "requirements",
      "scss",
      "ssh_config",
      "tmux",
      "toml",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    },
    auto_install = false, -- Autoinstall languages that are not installed
    highlight = {
      enable = true,
      disable = { "tex" },
    },
    indent = {
      enable = true,
      disable = {},
    },
    fold = {
      enable = true,
      disable = {},
    },
  },
  config = function(_, opts)
    local TS = require("nvim-treesitter")
    local parsers = opts.ensure_installed

    TS.install(parsers)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = parsers,
      callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local filetype = vim.bo[bufnr].filetype
        local lang = vim.treesitter.language.get_lang(filetype) or filetype

        -- syntax highlighting, provided by Neovim
        if is_feature_enabled(opts.highlight, lang, bufnr) then
          vim.treesitter.start(bufnr, lang)
        end

        -- folds, provided by Neovim
        if is_feature_enabled(opts.fold, lang, bufnr) then
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo.foldmethod = "expr"
        end

        -- indentation, provided by nvim-treesitter
        if is_feature_enabled(opts.indent, lang, bufnr) then
          vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
