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
  },
  config = function(_, opts)
    local TS = require("nvim-treesitter")
    local parsers = opts.ensure_installed

    TS.install(parsers)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = parsers,
      callback = function()
        -- syntax highlighting, provided by Neovim
        vim.treesitter.start()
        -- folds, provided by Neovim
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldmethod = "expr"
        -- indentation, provided by nvim-treesitter
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
