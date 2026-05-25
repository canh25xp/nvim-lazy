-- Native Neovim 0.12+ plugin manager using vim.pack.add
local M = {}

local DEFAULT_PRIORITY = 50

function M.resolve_src(src)
  if type(src) ~= "string" then
    return nil
  end
  if not src:match("^https?://") and not src:match("^git@") then
    return "https://github.com/" .. src
  end
  return src
end

function M.repo_name(src)
  return (src:match("([^/]+)$") or ""):gsub("%.git$", "")
end

local function is_enabled(spec)
  if spec.enabled == false then
    return false
  end
  if type(spec.enabled) == "function" and not spec.enabled(spec) then
    return false
  end
  if spec.cond == false then
    return false
  end
  if type(spec.cond) == "function" and not spec.cond(spec) then
    return false
  end
  return true
end

local function resolve_version(version)
  if version == false or version == nil then
    return nil
  end
  if type(version) == "string" and (version == "*" or version:match("[%*%^%~%><=]")) then
    local ok, range = pcall(vim.version.range, version)
    if ok then
      return range
    end
  end
  return version
end

local function find_spec(name)
  for _, spec in ipairs(M.specs) do
    if spec.name == name then
      return spec
    end
  end
end

--- Enrich an existing stub (e.g. from dependencies = { "user/repo" }) with a full plugin spec.
local function merge_into_spec(spec, raw)
  if raw.priority then
    spec.priority = raw.priority
  end
  if raw.opts ~= nil then
    spec.opts = raw.opts
  end
  if raw.config ~= nil then
    spec.config = raw.config
  end
  if raw.init then
    spec.init = raw.init
  end
  if raw.build then
    spec.build = raw.build
  end
  if raw.keys then
    spec.keys = raw.keys
  end
  if raw.main then
    spec.main = raw.main
  end
  local version = resolve_version(raw.version)
  if version then
    spec.version = version
  end
end

local normalize_spec

local function normalize_deps(raw, seen)
  local deps = raw.dependencies
  if type(deps) == "string" then
    deps = { deps }
  end
  if type(deps) == "table" then
    for _, dep in ipairs(deps) do
      normalize_spec(dep, seen)
    end
  end
end

normalize_spec = function(raw, seen)
  if type(raw) == "string" then
    raw = { raw }
  end
  if type(raw) ~= "table" then
    return
  end

  if type(raw[1]) == "table" or (#raw > 0 and type(raw[1]) ~= "string") then
    for _, item in ipairs(raw) do
      normalize_spec(item, seen)
    end
    return
  end

  if not is_enabled(raw) then
    return
  end

  local src = M.resolve_src(raw[1] or raw.src)
  if not src then
    return
  end

  local name = raw.name or M.repo_name(src)
  if name == "" then
    return
  end

  if seen[name] then
    local existing = find_spec(name)
    if existing then
      merge_into_spec(existing, raw)
    end
    normalize_deps(raw, seen)
    return
  end
  seen[name] = true

  local spec = {
    src = src,
    name = name,
    version = resolve_version(raw.version),
    priority = raw.priority or DEFAULT_PRIORITY,
    opts = raw.opts,
    config = raw.config,
    init = raw.init,
    build = raw.build,
    keys = raw.keys,
    main = raw.main,
  }

  table.insert(M.specs, spec)

  normalize_deps(raw, seen)
end

local function load_specs()
  M.specs = {}
  local seen = {}
  local plugins_dir = vim.fn.stdpath("config") .. "/lua/plugins"
  local ok, entries = pcall(vim.fs.dir, plugins_dir)
  if not ok then
    vim.notify("Could not read plugins directory: " .. tostring(entries), vim.log.levels.ERROR)
    return
  end

  for name, typ in entries do
    if typ == "file" and name:match("%.lua$") then
      local modname = "plugins." .. name:sub(1, -5)
      local ok_req, spec = pcall(require, modname)
      if ok_req then
        normalize_spec(spec, seen)
      else
        vim.notify("Failed to load " .. modname .. ": " .. tostring(spec), vim.log.levels.WARN)
      end
    end
  end

  table.sort(M.specs, function(a, b)
    return a.priority > b.priority
  end)
end

local function main_module(spec)
  if spec.main then
    return spec.main
  end
  return spec.name:gsub("%.nvim$", ""):gsub("%.lua$", "")
end

local function resolve_opts(spec)
  local opts = spec.opts or {}
  if type(opts) == "function" then
    opts = opts(spec, {}) or {}
  end
  return opts
end

local function run_init(spec)
  if type(spec.init) == "function" then
    pcall(spec.init, spec)
  end
end

local function run_config(spec)
  local opts = resolve_opts(spec)
  if type(spec.config) == "function" then
    local ok, err = pcall(spec.config, spec, opts)
    if not ok then
      vim.notify("config failed for " .. spec.name .. ": " .. tostring(err), vim.log.levels.ERROR)
    end
    return
  end

  if spec.config == false then
    return
  end

  if spec.config == nil and spec.opts == nil then
    return
  end

  local main = main_module(spec)
  if main == "" then
    return
  end

  local ok, mod = pcall(require, main)
  if ok and type(mod) == "table" and type(mod.setup) == "function" then
    local ok_setup, err = pcall(mod.setup, opts)
    if not ok_setup then
      vim.notify("setup failed for " .. main .. ": " .. tostring(err), vim.log.levels.ERROR)
    end
  end
end

local function register_keys(spec)
  if type(spec.keys) ~= "table" then
    return
  end

  for _, key in ipairs(spec.keys) do
    local lhs, rhs = key[1], key[2]
    if lhs and rhs then
      local map_opts = { desc = key.desc }
      for k, v in pairs(key) do
        if type(k) == "string" and k ~= "mode" and k ~= "desc" then
          map_opts[k] = v
        end
      end
      vim.keymap.set(key.mode or "n", lhs, rhs, map_opts)
    end
  end
end

local function run_build(spec)
  if spec.build == nil then
    return
  end
  if type(spec.build) == "string" then
    local ok, err = pcall(spec.build, spec)
    if not ok then
      vim.notify("build failed for " .. spec.name .. ": " .. tostring(err), vim.log.levels.ERROR)
    end
  elseif type(spec.build) == "function" then
    local ok, err = pcall(vim.fn.system, spec.build)
    if not ok then
      vim.notify("build failed for " .. spec.name .. ": " .. tostring(err), vim.log.levels.ERROR)
    end
  end
end

function M.setup(opts)
  opts = opts or {}
  local performance = opts.performance or {}
  if performance.vim_loader ~= false then
    vim.loader.enable()
  end

  load_specs()

  for _, spec in ipairs(M.specs) do
    run_init(spec)
  end

  -- Track plugins installed this session (lockfile sync or fresh clone).
  local installed = {}
  vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
      if ev.data.kind == "install" then
        installed[ev.data.spec.name] = true
      end
    end,
  })

  local pack_specs = {}
  for _, spec in ipairs(M.specs) do
    table.insert(pack_specs, {
      src = spec.src,
      name = spec.name,
      version = spec.version,
    })
  end

  if #pack_specs > 0 then
    local ok, err = pcall(vim.pack.add, pack_specs, { confirm = false, load = true })
    if not ok then
      vim.notify("vim.pack.add failed: " .. tostring(err), vim.log.levels.ERROR)
    end
  end

  for _, spec in ipairs(M.specs) do
    run_config(spec)
    register_keys(spec)
    if installed[spec.name] then
      run_build(spec)
    end
  end

  vim.api.nvim_create_autocmd("UIEnter", {
    once = true,
    callback = function()
      vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazy" })
    end,
  })

  require("config.pack_commands").setup(M)
end

function M.spec_names()
  local names = {}
  for _, spec in ipairs(M.specs or {}) do
    names[#names + 1] = spec.name
  end
  return names
end

M.setup()

return M
