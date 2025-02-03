vim.keymap.set({ "n", "o", "x" }, "]`", function()
  require("nvim-treesitter.textobjects.move").goto_next_start("@codeblock.inner")
end, { desc = "Goto next start @codeblock.inner", buffer = 0 })

vim.keymap.set({ "n", "o", "x" }, "[`", function()
  require("nvim-treesitter.textobjects.move").goto_previous_start("@codeblock.inner")
end, { desc = "Goto previous start @codeblock.inner", buffer = 0 })

require("which-key").add({"<localleader>o", buffer = 0, group = "Otter" })
vim.keymap.set("n", "<localleader>oa", function()
  require("otter").activate()
end, { desc = "Activate otter", buffer = 0 })
vim.keymap.set("n", "<localleader>od", function()
  require("otter").deactivate()
end, { desc = "Deactivate otter", buffer = 0 })

local ai = require("mini.ai")
vim.b.miniai_config = {
  custom_textobjects = {
    ["`"] = ai.gen_spec.treesitter({
      a = { "@codeblock.outer" },
      i = { "@codeblock.inner" },
    }),
  }
}

if require("util.plugins").has("vim-slime") then
  vim.keymap.set("n", "<localleader><cr>", "<Plug>SlimeMotionSendi`", { desc = "Send cell", buffer = 0, remap = true })
  vim.keymap.set("n", "<localleader> ", "<Plug>SlimeLineSend", { desc = "Send line", buffer = 0 })
  vim.keymap.set(
    "n",
    "<localleader><localleader>",
    "<Plug>SlimeLineSend<cr>",
    { desc = "Send line and go next", buffer = 0 }
  )
  vim.keymap.set("n", "<localleader>s", "<Plug>SlimeMotionSend", { desc = "Send motion", buffer = 0 })
  vim.keymap.set("n", "<localleader>c", "<Plug>SlimeConfig", { desc = "Vim-slime config", buffer = 0 })
  vim.keymap.set("x", "<localleader><cr>", "<Plug>SlimeRegionSend", { desc = "Send selection", buffer = 0 })
end
