return {
  on_init = function(client)
    local ok, schemastore = pcall(require, "schemastore")

    client.config.settings.json = vim.tbl_deep_extend("force", client.config.settings.json or {}, {
      schemas = ok and schemastore.json.schemas() or {},
      validate = { enable = true },
    })
  end,
  settings = {
    json = {
      format = {
        enable = true,
      },
      validate = { enable = true },
    },
  },
}
