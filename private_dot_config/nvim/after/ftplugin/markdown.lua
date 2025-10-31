vim.keymap.set({ "n", "o", "x" }, "]`", function()
  require("nvim-treesitter.textobjects.move").goto_next_start("@codeblock.inner")
end, { desc = "Goto next start @codeblock.inner", buffer = 0 })

vim.keymap.set({ "n", "o", "x" }, "[`", function()
  require("nvim-treesitter.textobjects.move").goto_previous_start("@codeblock.inner")
end, { desc = "Goto previous start @codeblock.inner", buffer = 0 })

local ai = require("mini.ai")
vim.b.miniai_config = {
  custom_textobjects = {
    ["`"] = ai.gen_spec.treesitter({
      a = { "@codeblock.outer" },
      i = { "@codeblock.inner" },
    }),
  },
}
