local ci_selector = require("common.ci_selector")

local function setup_terminal_exit_keymap(buf)
  local terminal = vim.b[buf].snacks_terminal
  local cmd = terminal and terminal.cmd

  if type(cmd) == "table" then
    cmd = cmd[1]
  end

  if type(cmd) == "string" then
    cmd = vim.fn.fnamemodify(cmd, ":t")
  end

  -- Only map for shell terminals (no explicit command), not tool UIs like lazygit/btm/yazi.
  if cmd ~= nil then
    return
  end

  vim.keymap.set("t", "jk", "<C-\\><C-n>", {
    buffer = buf,
    desc = "Exit Terminal Mode",
    silent = true,
  })
end

local function send_line_to_terminal()
  -- get the first snacks terminal
  local terms = Snacks.terminal.list()
  if #terms == 0 then
    print("No terminal open")
    return
  end

  local term = terms[1]
  local chan = vim.b[term.buf].terminal_job_id

  local line = vim.api.nvim_get_current_line()

  vim.fn.chansend(chan, line .. "\n")
end

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
        on_buf = function(self)
          setup_terminal_exit_keymap(self.buf)
        end,
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
    { "<leader>ci",   function() ci_selector.ci() end, desc = "Code Intelligent" },
    { "<leader>rr",   send_line_to_terminal, desc = "Run current line" }
  },
}
