local M = {}

local pack ---@type table

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO)
end

local function pack_call(fn, err_prefix)
  local ok, err = pcall(fn)
  if not ok then
    notify(("%s: %s"):format(err_prefix, err), vim.log.levels.ERROR)
  end
  return ok
end

local function plugin_names()
  local names = {}
  local seen = {}

  for _, name in ipairs(pack.spec_names()) do
    if not seen[name] then
      seen[name] = true
      names[#names + 1] = name
    end
  end

  local ok, installed = pcall(vim.pack.get, nil, { info = false })
  if ok and installed then
    for _, p in ipairs(installed) do
      local name = p.spec.name
      if name and not seen[name] then
        seen[name] = true
        names[#names + 1] = name
      end
    end
  end

  table.sort(names)
  return names
end

local function complete_names(arglead)
  local lead = (arglead or ""):lower()
  if lead == "" then
    return plugin_names()
  end
  return vim.tbl_filter(function(name)
    return name:lower():find(lead, 1, true) == 1
  end, plugin_names())
end

local function resolve_plugin_arg(arg)
  if not arg or arg == "" then
    return nil
  end
  return arg
end

local function is_bang(opts)
  return opts.bang == 1 or opts.bang == true
end

local function name_set(names)
  local set = {}
  for _, name in ipairs(names) do
    set[name] = true
  end
  return set
end

local function read_lockfile_versions()
  local path = vim.fn.stdpath("config") .. "/nvim-pack-lock.json"
  local ok, data = pcall(vim.fn.readfile, path)
  if not ok or not data or #data == 0 then
    return {}
  end
  local decoded = vim.json.decode(table.concat(data, "\n"))
  local versions = {}
  if type(decoded) == "table" and type(decoded.plugins) == "table" then
    for name, info in pairs(decoded.plugins) do
      if type(info) == "table" and info.version then
        versions[name] = info.version
      end
    end
  end
  return versions
end

function M.pack_add(repo)
  if not repo or repo == "" then
    notify("Usage: PackAdd {user/repo}", vim.log.levels.WARN)
    return
  end

  local src = pack.resolve_src(repo)
  if not src then
    notify("Invalid plugin source: " .. repo, vim.log.levels.ERROR)
    return
  end

  local name = pack.repo_name(src)
  pack_call(function()
    vim.pack.add({ { src = src, name = name } }, { confirm = false, load = true })
  end, "PackAdd failed")

  notify(("Installed %s. Add a spec under lua/plugins/ for config; restart may be needed."):format(name))
end

function M.pack_remove(name)
  name = resolve_plugin_arg(name)
  if not name then
    notify("Usage: PackRemove {plugin-name}", vim.log.levels.WARN)
    return
  end

  pack_call(function()
    vim.pack.del({ name }, { force = true })
  end, "PackRemove failed")

  notify(("%s removed. Restart Neovim or remove it from lua/plugins/ if no longer needed."):format(name), vim.log.levels.WARN)
end

function M.pack_restore(name, bang)
  local names = name and { name } or nil
  local opts = { target = "lockfile" }
  if bang then
    opts.force = true
  end

  pack_call(function()
    if names then
      vim.pack.update(names, opts)
    else
      vim.pack.update(nil, opts)
    end
  end, "PackRestore failed")
end

function M.pack_upgrade(name, bang)
  local names = name and { name } or nil
  local opts = bang and { force = true } or nil

  pack_call(function()
    if names and opts then
      vim.pack.update(names, opts)
    elseif names then
      vim.pack.update(names)
    elseif opts then
      vim.pack.update(nil, opts)
    else
      vim.pack.update()
    end
  end, "PackUpgrade failed")
end

function M.pack_list()
  vim.pack.update(nil, { offline = true })
end

function M.pack_clean()
  local wanted = name_set(pack.spec_names())
  local to_delete = {}

  local ok, installed = pcall(vim.pack.get, nil, { info = false })
  if not ok or not installed then
    notify("PackClean failed: " .. tostring(installed), vim.log.levels.ERROR)
    return
  end

  for _, p in ipairs(installed) do
    local name = p.spec.name
    if name and not wanted[name] then
      to_delete[#to_delete + 1] = name
    end
  end

  if #to_delete == 0 then
    notify("No unused plugins to clean", vim.log.levels.INFO)
    return
  end

  pack_call(function()
    vim.pack.del(to_delete, { force = true })
  end, "PackClean failed")

  notify(("Deleted %d unused plugin(s): %s"):format(#to_delete, table.concat(to_delete, ", ")))
end

function M.pack_nuke(bang)
  if not bang then
    notify("PackNuke is destructive. Use :PackNuke! to delete all vim.pack plugins.", vim.log.levels.WARN)
    return
  end

  local ok, installed = pcall(vim.pack.get, nil, { info = false })
  if not ok or not installed or #installed == 0 then
    notify("No plugins to delete", vim.log.levels.INFO)
    return
  end

  local names = {}
  for _, p in ipairs(installed) do
    if p.spec.name then
      names[#names + 1] = p.spec.name
    end
  end

  pack_call(function()
    vim.pack.del(names, { force = true })
  end, "PackNuke failed")

  notify(
    ("Deleted all %d plugin(s). Restart Neovim to reinstall from lua/plugins/."):format(#names),
    vim.log.levels.WARN
  )
end

function M.setup(pack_mod)
  pack = pack_mod

  vim.api.nvim_create_user_command("PackAdd", function(opts)
    M.pack_add(opts.args)
  end, { nargs = 1, desc = "Install a plugin (user/repo or URL)" })

  vim.api.nvim_create_user_command("PackRemove", function(opts)
    M.pack_remove(opts.args)
  end, {
    nargs = 1,
    desc = "Remove a plugin from disk",
    complete = function(_, _, arglead)
      return complete_names(arglead)
    end,
  })

  vim.api.nvim_create_user_command("PackRestore", function(opts)
    M.pack_restore(resolve_plugin_arg(opts.args), is_bang(opts))
  end, {
    nargs = "?",
    bang = true,
    desc = "Restore plugins to lockfile revisions",
    complete = function(_, _, arglead)
      return complete_names(arglead)
    end,
  })

  vim.api.nvim_create_user_command("PackUpgrade", function(opts)
    M.pack_upgrade(resolve_plugin_arg(opts.args), is_bang(opts))
  end, {
    nargs = "?",
    bang = true,
    desc = "Update plugins to latest matching version",
    complete = function(_, _, arglead)
      return complete_names(arglead)
    end,
  })

  vim.api.nvim_create_user_command("PackList", function()
    M.pack_list()
  end, { desc = "List installed plugins" })

  vim.api.nvim_create_user_command("PackClean", function()
    M.pack_clean()
  end, { desc = "Remove plugins not in lua/plugins specs" })

  vim.api.nvim_create_user_command("PackNuke", function(opts)
    M.pack_nuke(is_bang(opts))
  end, { bang = true, desc = "Delete all vim.pack plugins (use !)" })
end

return M
