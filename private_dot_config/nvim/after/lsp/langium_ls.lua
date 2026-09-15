return {
  cmd = {
    "langiumls",
    "--stdio",
  },
  filetypes = { "langium" },
  root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
  workspace_required = false,
  settings = {
    langium = {
      build = {
        ignorePatterns = "node_modules, out",
      },
    },
  },
}
