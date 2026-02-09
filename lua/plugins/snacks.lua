local ci_selector = require("common.ci_selector")

return {
  "snacks.nvim",
  opts = {
    scroll = {
      enabled = not vim.g.is_windows,
    },
    styles = {
      lazygit = {
        height = 0,
        width = 0,
        border = "none",
      },
    },
    terminal = {
      win = {
        wo = {
          winbar = "",
        },
        keys = {
          hide_slash = { "<C-\\>", "hide", desc = "Hide Terminal", mode = { "t", "n" } },
        },
      },
    },
    bigfile = {
      setup = function(ctx)
        if vim.fn.exists(":NoMatchParen") ~= 0 then
          vim.cmd([[NoMatchParen]])
        end
        Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0 })
        vim.b.completion = false
        vim.b.minianimate_disable = true
        vim.b.minihipatterns_disable = true
        vim.b.snacks_animate = false
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(ctx.buf) then
            vim.bo[ctx.buf].syntax = ctx.ft
          end
        end)
      end,
    },
    picker = {
      sources = {
        files = {
          layout = {
            fullscreen = true,
          },
        },
        grep = {
          layout = {
            fullscreen = true,
          },
        },
        explorer = {
          win = {
            list = {
              keys = {
                ["<A-h>"] = false,
                ["<A-i>"] = false,
              },
            },
          },
        },
      },
    },
  },
  -- stylua: ignore
  keys = {
    { "<C-\\>",       function() Snacks.terminal() end, desc = "Toggle Terminal" },
    { "<leader>tt",   function() Snacks.terminal(nil, { cwd = LazyVim.root(), win = { position = "float", width = 0, height = 0, border = "none" } }) end, desc = "Terminal Fullscreen" },
    { "<leader>lf",   function() Snacks.terminal({ "lf" }, { win = { style = "lazygit" } }) end, desc = "List Files" },
    { "<leader>ya",   function() Snacks.terminal({ "yazi" }, { win = { style = "lazygit" } }) end, desc = "Yazi" },
    { "<leader>bt",   function() Snacks.terminal({ "btm" }, { win = { style = "lazygit" } }) end, desc = "Bottom" },
    { "<leader>ci",   function() ci_selector.ci() end, desc = "Code Intelligent" }
  },
}
