local function trim(s)
  if vim.trim then
    return vim.trim(s)
  end
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function starts_with(str, prefix)
  if vim.startswith then
    return vim.startswith(str, prefix)
  end
  return str:sub(1, #prefix) == prefix
end

local function get_patterns_file()
  return vim.g.vimgrep_patterns_file or (vim.fn.stdpath("config") .. "/grep_patterns")
end

local function ensure_patterns_file(path)
  if vim.fn.filereadable(path) == 1 then
    return true
  end
  local ok, err = pcall(vim.fn.writefile, {}, path)
  if not ok then
    vim.notify(("Unable to create vimgrep pattern file at %s: %s"):format(path, err), vim.log.levels.ERROR)
  end
  return ok
end

local function read_patterns()
  local path = get_patterns_file()
  if not ensure_patterns_file(path) then
    return {}
  end
  local lines = vim.fn.readfile(path)
  local patterns = {}
  for _, line in ipairs(lines) do
    local cleaned = trim(line)
    if cleaned ~= "" and not starts_with(cleaned, "#") then
      table.insert(patterns, cleaned)
    end
  end
  return patterns, path
end

local function select_pattern(patterns, callback)
  if vim.ui and vim.ui.select then
    vim.ui.select(patterns, { prompt = "Select vimgrep pattern" }, callback)
    return
  end
  local choices = { "Select vimgrep pattern:" }
  for index, pattern in ipairs(patterns) do
    choices[#choices + 1] = ("%d. %s"):format(index, pattern)
  end
  local choice = vim.fn.inputlist(choices)
  callback(patterns[choice])
end

vim.api.nvim_create_user_command("GrepPatterns", function()
  local patterns, path = read_patterns()
  if vim.tbl_isempty(patterns) then
    vim.notify(("No saved vimgrep patterns found in %s"):format(path), vim.log.levels.WARN)
    return
  end
  select_pattern(patterns, function(pattern)
    if not pattern then
      return
    end
    local cmd = ("vimgrep %s %%"):format(pattern:gsub("%%", "%%%%"))
    vim.cmd(cmd)
  end)
end, {
  desc = "Grep current buffer from a list of saved pattern",
})
