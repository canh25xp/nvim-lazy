local function MasonEnsureInstall(pkgs)
  local registry = require("mason-registry")
  registry.refresh()

  local missing = {}
  for _, pkg_name in ipairs(pkgs) do
    local ok, pkg = pcall(registry.get_package, pkg_name)
    if ok and pkg and not pkg:is_installed() then
      missing[#missing + 1] = pkg_name
    end
  end

  if #missing == 0 then
    vim.notify("All Mason packages are already installed", vim.log.levels.INFO)
    return
  end

  vim.notify("Installing Mason packages: " .. table.concat(missing, ", "), vim.log.levels.INFO)

  -- Headless CLI (+MasonEnsureInstall +q) must block until installs finish.
  if require("mason-core.platform").is_headless then
    vim.cmd(("MasonInstall %s"):format(table.concat(missing, " ")))
    return
  end

  for _, pkg_name in ipairs(missing) do
    registry.get_package(pkg_name):install()
  end
end

return {
  "mason-org/mason.nvim",
  lazy = false,
  keys = {
    { "<leader>cI", "<cmd>MasonEnsureInstall<cr>", desc = "Install Mason Packages" },
  },
  config = function(_, opts)
    require("mason").setup(opts)
    vim.api.nvim_create_user_command("MasonEnsureInstall", function()
      local ensure_installed = opts.ensure_installed
      print(vim.inspect(ensure_installed))
      MasonEnsureInstall(ensure_installed)
    end, { desc = "Install all Mason ensured packages" })
  end,
}
