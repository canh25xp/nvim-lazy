return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    checkbox = {
      enabled = true,
      bullet = false,
      unchecked = {
        icon = "󰄱 ",
        highlight = "RenderMarkdownUnchecked",
        scope_highlight = nil,
      },
      checked = {
        icon = "󰱒 ",
        highlight = "RenderMarkdownChecked",
        scope_highlight = "@markup.strikethrough",
      },
      -- stylua: ignore
      custom = {
        progress    = { raw = "[/]", rendered = "󰿠 ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
        onhold      = { raw = "[<]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
        abort       = { raw = "[-]", rendered = "󰜺 ", highlight = "RenderMarkdownError", scope_highlight = "@markup.strikethrough" },
        forward     = { raw = "[>]", rendered = " ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
        question    = { raw = "[?]", rendered = " ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
        important   = { raw = "[!]", rendered = " ", highlight = "RenderMarkdownWarn", scope_highlight = nil },
      },
    },
  },
}
