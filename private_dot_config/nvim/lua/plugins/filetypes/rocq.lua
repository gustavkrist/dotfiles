return {
  {
    "whonore/Coqtail",
    init = function()
      vim.g.loaded_coqtail = 1
      vim.g["coqtail#supported"] = 0
    end,
  },
  {
    "tomtomjhj/vsrocq.nvim",
    ft = "coq",
    dependecies = {
      "whonore/Coqtail",
    },
    opts = {
      vsrocq = {
        proof = {
          cursor = { sticky = false },
          -- delegation = "Skip",
        },
        completion = {
          enable = true,
        },
        diagnostics = {
          full = false,
        },
      },
      lsp = {
        on_attach = function(_, bufnr)
          -- In manual mode, use ctrl-alt-{j,k,l} to step.
          vim.keymap.set(
            { "n", "i" },
            "<C-M-j>",
            "<Cmd>VsRocq stepForward<CR>",
            { buffer = bufnr, desc = "VsRocq step forward" }
          )
          vim.keymap.set(
            { "n", "i" },
            "<C-M-k>",
            "<Cmd>VsRocq stepBackward<CR>",
            { buffer = bufnr, desc = "VsRocq step backward" }
          )
          vim.keymap.set(
            { "n", "i" },
            "<C-M-l>",
            "<Cmd>VsRocq interpretToPoint<CR>",
            { buffer = bufnr, desc = "VsRocq interpret to point" }
          )
          vim.keymap.set(
            { "n", "i" },
            "<C-M-G>",
            "<Cmd>VsRocq interpretToEnd<CR>",
            { buffer = bufnr, desc = "VsRocq interpret to end" }
          )
          vim.keymap.set(
            { "n" },
            "<localleader>e",
            "<Cmd>VsRocq jumpToEnd<CR>",
            { buffer = bufnr, desc = "VsRocq jump to end" }
          )
        end,
        -- cmd = { 'vsrocqtop', '-bt', '-vsrocq-d', 'all' },
      },
    },
  },
}
