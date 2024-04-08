return {
  {
    "lervag/vimtex",
    config = function()
      vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
      vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
      vim.g.tex_flavor = "latex"
      -- vim.g.tex_conceal = "abdmgs"
      vim.g.vimtex_quickfix_mode = 0
      -- vim.g.vimtex_quickfix_autoclose_after_keystrokes = 1
      -- vim.g.vimtex_compiler_latexmk_engines = { ["_"] = "-lualatex" }
      vim.g.vimtex_view_enabled = 1
      vim.g.vimtex_view_automatic = 0
      vim.g.vimtex_doc_handlers = {'vimtex#doc#handlers#texdoc'}
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = {},
      },
    },
  },
  {
    "lukas-reineke/headlines.nvim",
    enabled = false,
  },
}
