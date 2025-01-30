local specs = {}

specs = vim.list_extend(specs, require("plugins.ai"))
specs = vim.list_extend(specs, require("plugins.base"))
specs = vim.list_extend(specs, require("plugins.colorschemes"))
specs = vim.list_extend(specs, require("plugins.completion"))
specs = vim.list_extend(specs, require("plugins.filetypes.chezmoi"))
specs = vim.list_extend(specs, require("plugins.filetypes.fsharp"))
specs = vim.list_extend(specs, require("plugins.filetypes.latex"))
specs = vim.list_extend(specs, require("plugins.filetypes.markdown"))
specs = vim.list_extend(specs, require("plugins.filetypes.plist"))
specs = vim.list_extend(specs, require("plugins.filetypes.python"))
specs = vim.list_extend(specs, require("plugins.lsp"))
specs = vim.list_extend(specs, require("plugins.lualine"))
specs = vim.list_extend(specs, require("plugins.mini"))
specs = vim.list_extend(specs, require("plugins.picker-grapple"))
specs = vim.list_extend(specs, require("plugins.snacks"))
specs = vim.list_extend(specs, require("plugins.treesitter"))
specs = vim.list_extend(specs, require("plugins.utility"))
specs = vim.list_extend(specs, require("plugins.visual"))

local final_specs = {}

for _, spec in ipairs(specs) do
  if type(spec) == "string" then
    spec = { spec }
  end
  spec.cond = require("util.plugins").should_enable_cond(spec)
  table.insert(final_specs, spec)
end

return final_specs
