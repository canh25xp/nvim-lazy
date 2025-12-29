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

local function normalize_path(path)
  if not path or path == "" then
    return nil
  end
  local expanded = vim.fn.expand(path)
  local ok, normalized = pcall(vim.fn.fnamemodify, expanded, ":p")
  if ok and normalized and normalized ~= "" then
    return normalized
  end
  return expanded ~= "" and expanded or path
end

local function get_patterns_file()
  local seen = {}
  local paths = {}

  local function add_path(path)
    path = normalize_path(path)
    if path and not seen[path] then
      seen[path] = true
      paths[#paths + 1] = path
    end
  end

  local override = vim.g.vimgrep_patterns_file
  if type(override) == "string" then
    add_path(override)
  elseif type(override) == "table" then
    for _, path in ipairs(override) do
      add_path(path)
    end
  end

  add_path(vim.fn.stdpath("config") .. "/grep_patterns")

  local home
  if vim.loop and vim.loop.os_homedir then
    home = vim.loop.os_homedir()
  else
    home = vim.env.HOME
  end
  if home and home ~= "" then
    add_path(home .. "/grep_patterns")
  end

  local cwd = vim.fn.getcwd()
  if cwd and cwd ~= "" then
    add_path(cwd .. "/grep_patterns")
  end

  return paths
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
  local paths = get_patterns_file()
  if vim.tbl_isempty(paths) then
    return {}, ""
  end

  local readable_paths = {}
  for _, path in ipairs(paths) do
    if vim.fn.filereadable(path) == 1 then
      readable_paths[#readable_paths + 1] = path
    end
  end

  if vim.tbl_isempty(readable_paths) then
    local primary = paths[1]
    if not ensure_patterns_file(primary) then
      return {}, primary
    end
    readable_paths = { primary }
  end

  local patterns = {}
  local dedup = {}
  for _, path in ipairs(readable_paths) do
    local lines = vim.fn.readfile(path)
    for _, line in ipairs(lines) do
      local cleaned = trim(line)
      if cleaned ~= "" and not starts_with(cleaned, "#") and not dedup[cleaned] then
        dedup[cleaned] = true
        table.insert(patterns, cleaned)
      end
    end
  end

  local display_path = table.concat(readable_paths, ", ")
  return patterns, display_path
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
