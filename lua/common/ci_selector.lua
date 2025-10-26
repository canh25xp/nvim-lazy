local M = {}

local choices = { "cline", "codex", "gemini", "copilot", "qwen" }
local data_file = vim.fn.stdpath("config") .. "/.options.txt"

local function run_with_choice(choice)
  Snacks.terminal({ choice }, { win = { style = "lazygit" } })
end

function M.ci()
  local choice = nil
  if (vim.uv or vim.loop).fs_stat(data_file) then
    local file = io.open(data_file, "r")
    if file then
      choice = file:read("*a"):gsub("%s+", "")
      file:close()
      if not vim.tbl_contains(choices, choice) then
        choice = nil
      end
    end
  end
  if choice then
    run_with_choice(choice)
  else
    vim.ui.select(choices, {
      prompt = "Select Code Intelligence Tool:",
      format_item = function(item)
        return item
      end,
    }, function(selected)
      if selected then
        local file = io.open(data_file, "w")
        if file then
          file:write(selected)
          file:close()
        end
        run_with_choice(selected)
      end
    end)
  end
end

return M
