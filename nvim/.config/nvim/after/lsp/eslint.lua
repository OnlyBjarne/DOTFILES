return {
  before_init = function(params, config)
    -- Set the workspace folder setting for correct search of tsconfig.json files etc.
    config.settings.workspaceFolder = {
      uri = params.rootPath,
      name = vim.fn.fnamemodify(params.rootPath, ":t"),
    }
  end,
  root_markers = { ".eslintrc", ".eslintrc.js", ".eslintrc.json", "eslint.config.js", "eslint.config.mjs" },
  handlers = {
    ["eslint/openDoc"] = function(_, params)
      vim.ui.open(params.url)
      return {}
    end,
    ["eslint/probeFailed"] = function()
      vim.notify("LSP[eslint]: Probe failed.", vim.log.levels.WARN)
      return {}
    end,
    ["eslint/noLibrary"] = function()
      vim.notify("LSP[eslint]: Unable to load ESLint library.", vim.log.levels.WARN)
      return {}
    end,
    ["eslint/confirmESLintExecution"] = function(_, result)
      if not result then
        return
      end
      return 4 -- approved
    end,
  },
}
