local filetypes = { "cpp" }

return {
  {
    "mfussenegger/nvim-dap",
    ft = filetypes,
    config = function()
      local dap = require("dap")

      -- Signs
      for _, group in pairs({
        "DapBreakpoint",
        "DapBreakpointCondition",
        "DapBreakpointRejected",
        "DapLogPoint",
      }) do
        vim.fn.sign_define(group, { text = "●", texthl = "DapUIStop" })
      end
      vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", numhl = "debugPC" })

      -- dap.defaults.fallback.switchbuf = "usevisible,usetab,newtab"

      dap.adapters.codelldb = {
        type = "executable",
        command = "codelldb",
      }

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("nvim-dap-local-binds", { clear = true }),
        pattern = filetypes,
        callback = function() end,
      })
    end,
    keys = function()
      local dap = require("dap")
      return {
        {
          "<F4>",
          function()
            dap.terminate({ hierarchy = true })
          end,
          desc = "DAP Terminate",
          ft = filetypes,
        },
        { "<F5>", dap.continue, desc = "DAP Continue", ft = filetypes },
        {
          "<F8>",
          function()
            vim.ui.input({ prompt = "Log point message: " }, function(input)
              dap.set_breakpoint(nil, nil, input)
            end)
          end,
          desc = "Toggle Logpoint",
          ft = filetypes,
        },
        { "<F9>", dap.toggle_breakpoint, desc = "Toggle Breakpoint", ft = filetypes },
        { "<F10>", dap.step_over, desc = "Step Over", ft = filetypes },
        { "<F11>", dap.step_into, desc = "Step Into", ft = filetypes },
        { "<F12>", dap.step_out, desc = "Step Out", ft = filetypes },
        { "<localleader>fu", dap.up, desc = "DAP Frame Up", ft = filetypes },
        { "<localleader>fd", dap.down, desc = "DAP Frame Down", ft = filetypes },
        { "<localleader>rl", dap.run_last, desc = "DAP Run Last", ft = filetypes },
        { "<localleader>rc", dap.run_to_cursor, desc = "DAP Run to Cursor", ft = filetypes },
        {
          "<localleader>bc",
          function()
            vim.ui.input({ prompt = "Breakpoint condition: " }, function(input)
              dap.set_breakpoint(input)
            end)
          end,
          desc = "DAP Conditional Breakpoint",
          ft = filetypes,
        },
      }
    end,
  },
  {
    "igorlfs/nvim-dap-view",
    ft = filetypes,
    ---@module 'dap-view'
    ---@type dapview.Config
    opts = {},
    keys = function()
      local dapview = require("dap-view")
      return {
        { "<localleader>uv", dapview.toggle, desc = "Toggle DAP View", ft = filetypes },
        { "<localleader>w", dapview.add_expr, desc = "Watch Expression", ft = filetypes },
      }
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    ft = filetypes,
    opts = { enabled = false },
    keys = {
      {
        "<localleader>ut",
        "<cmd>DapVirtualTextToggle<cr>",
        desc = "Toggle DAP Virtual Text",
        ft = filetypes,
      },
    },
  },
  {
    "stevearc/overseer.nvim",
    ft = filetypes,
    opts = {},
  },
}
