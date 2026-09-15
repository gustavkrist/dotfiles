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
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "coq-goals", "coq-infos" },
        group = vim.api.nvim_create_augroup("vsrocq_wrap", { clear = true }),
        callback = function(ev)
          vim.defer_fn(function()
            local win = vim.tbl_filter(function(win)
              return vim.api.nvim_win_get_buf(win) == ev.buf
            end, vim.api.nvim_list_wins())[1]
            vim.wo[win].wrap = true
          end, 1000)
        end,
      })
    end,
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
