-- Native Neovim 0.12+ plugin manager using vim.pack.add
local M = {}

-- Helper to resolve GitHub shorthand repo names to full HTTPS URLs
local function resolve_src(src)
  if not src or type(src) ~= "string" then
    return nil
  end
  if not src:match("^http") and not src:match("^git@") then
    return "https://github.com/" .. src
  end
  return src
end

-- Helper to extract the repository name from a source URL
local function get_repo_name(src)
  if not src then
    return ""
  end
  return src:match("([^/]+)$"):gsub("%.git$", "")
end

-- Helper to resolve version constraints to vim.VersionRange if applicable
local function resolve_version(version)
  if type(version) == "string" then
    if version == "*" or version:match("[%*%^%~%><=]") then
      local ok, range = pcall(vim.version.range, version)
      if ok then
        return range
      end
    end
  end
  if version == false then
    return nil -- lazy.nvim version = false means default branch
  end
  return version
end

-- Helper to evaluate if a plugin is enabled based on enabled/cond fields
local function is_enabled(spec)
  if spec.enabled == false then
    return false
  end
  if type(spec.enabled) == "function" then
    if not spec.enabled(spec) then
      return false
    end
  end
  if spec.cond == false then
    return false
  end
  if type(spec.cond) == "function" then
    if not spec.cond(spec) then
      return false
    end
  end
  return true
end

-- Recursively gather all plugin specs and their dependencies
local function gather_specs(spec, all_specs, seen)
  if type(spec) ~= "table" then
    return
  end

  -- If it's a list-like spec (multiple specs returned in one file)
  if type(spec[1]) == "table" or (#spec > 0 and type(spec[1]) ~= "string") then
    for _, s in ipairs(spec) do
      gather_specs(s, all_specs, seen)
    end
    return
  end

  -- Single spec
  if not is_enabled(spec) then
    return
  end

  local src = spec[1] or spec.src
  if not src then
    return
  end

  src = resolve_src(src)
  local name = spec.name or get_repo_name(src)
  if name == "" then
    return
  end

  if seen[name] then
    -- Merge specifications if we've seen it (e.g. from dependencies and main list)
    local existing = all_specs[name]
    existing.enabled = existing.enabled ~= false and spec.enabled ~= false
    existing.cond = existing.cond ~= false and spec.cond ~= false
    if spec.opts then
      existing.opts = vim.tbl_deep_extend("force", existing.opts or {}, spec.opts or {})
    end
    if spec.config then
      existing.config = spec.config
    end
    if spec.keys then
      existing.keys = existing.keys or {}
      vim.list_extend(existing.keys, spec.keys)
    end
    return
  end

  local normalized = {
    src = src,
    name = name,
    version = resolve_version(spec.version),
    enabled = spec.enabled,
    cond = spec.cond,
    opts = spec.opts,
    config = spec.config,
    keys = spec.keys,
    init = spec.init,
    main = spec.main,
    dependencies = spec.dependencies,
  }

  seen[name] = true
  all_specs[name] = normalized

  -- Process dependencies recursively
  if spec.dependencies then
    local deps = spec.dependencies
    if type(deps) == "string" then
      deps = { deps }
    end
    if type(deps) == "table" then
      for _, dep in ipairs(deps) do
        if type(dep) == "string" then
          gather_specs({ dep }, all_specs, seen)
        else
          gather_specs(dep, all_specs, seen)
        end
      end
    end
  end
end

-- Load all specs from the lua/plugins directory
local function load_all_specs()
  local all_specs = {}
  local seen = {}

  local plugins_dir = vim.fn.stdpath("config") .. "/lua/plugins"

  -- Use vim.fs.dir to safely list directory contents
  local ok, entries = pcall(vim.fs.dir, plugins_dir)
  if not ok then
    vim.notify("Could not read plugins directory: " .. tostring(entries), vim.log.levels.ERROR)
    return {}
  end

  for name, type in entries do
    if type == "file" and name:match("%.lua$") then
      local modname = "plugins." .. name:sub(1, -5)
      local ok_req, spec = pcall(require, modname)
      if ok_req then
        gather_specs(spec, all_specs, seen)
      else
        vim.notify("Failed to load plugin config " .. modname .. ": " .. tostring(spec), vim.log.levels.WARN)
      end
    end
  end

  -- Filter and only return enabled specs
  local active_specs = {}
  for _, spec in pairs(all_specs) do
    if is_enabled(spec) then
      table.insert(active_specs, spec)
    end
  end

  return active_specs
end

-- Guess the main module name to require for default setup
local function get_main_module(spec)
  if spec.main then
    return spec.main
  end
  local name = spec.name or get_repo_name(spec.src)
  return name:gsub("%.nvim$", ""):gsub("%.lua$", "")
end

-- Run keybindings for a spec
local function register_keys(spec)
  if type(spec.keys) ~= "table" then
    return
  end
  for _, key in ipairs(spec.keys) do
    local lhs = key[1]
    local rhs = key[2]
    if lhs and rhs then
      local opts = { desc = key.desc }
      for k, v in pairs(key) do
        if type(k) == "string" and k ~= "mode" and k ~= "desc" then
          opts[k] = v
        end
      end
      local mode = key.mode or "n"
      vim.keymap.set(mode, lhs, rhs, opts)
    end
  end
end

-- Initialize and run config for an active spec
local function run_config(spec)
  -- Run init hook if defined
  if type(spec.init) == "function" then
    pcall(spec.init)
  end

  -- Register keymaps
  register_keys(spec)

  -- Resolve opts
  local opts = spec.opts or {}
  if type(opts) == "function" then
    opts = opts(spec, {}) or {}
  end

  -- Run config function or automatic fallback
  if type(spec.config) == "function" then
    local ok, err = pcall(spec.config, spec, opts)
    if not ok then
      vim.notify("Error in config for " .. spec.name .. ": " .. tostring(err), vim.log.levels.ERROR)
    end
  elseif spec.config == true or (spec.config == nil and spec.opts ~= nil) then
    local main = get_main_module(spec)
    if main ~= "" then
      local ok, mod = pcall(require, main)
      if ok and type(mod) == "table" and type(mod.setup) == "function" then
        local ok_setup, err = pcall(mod.setup, opts)
        if not ok_setup then
          vim.notify("Error running setup for " .. main .. ": " .. tostring(err), vim.log.levels.ERROR)
        end
      end
    end
  end
end

function M.setup()
  -- Load and resolve all plugin specifications
  local active_specs = load_all_specs()
  M.active_count = #active_specs

  -- Prepare specs for vim.pack.add
  local pack_specs = {}
  for _, spec in ipairs(active_specs) do
    table.insert(pack_specs, {
      src = spec.src,
      name = spec.name,
      version = spec.version,
    })
  end

  if #pack_specs > 0 then
    -- Native pack.add is synchronous and returns/loads everything cleanly
    local ok, err = pcall(vim.pack.add, pack_specs)
    if not ok then
      vim.notify("Error during native vim.pack.add: " .. tostring(err), vim.log.levels.ERROR)
    end
  end

  -- Configure all active plugins
  for _, spec in ipairs(active_specs) do
    run_config(spec)
  end
end

M.setup()

return M
