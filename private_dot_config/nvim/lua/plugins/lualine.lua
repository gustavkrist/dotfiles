local function not_excluded_filetype()
  return not vim.tbl_contains({
    "",
    "DressingSelect",
    "Jaq",
    "NvimTree",
    "Outline",
    "TelescopePrompt",
    "Trouble",
    "alpha",
    "checkhealth",
    "dap-repl",
    "dap-terminal",
    "dap-view",
    "dapui_console",
    "dapui_hover",
    "dashboard",
    "grapple",
    "harpoon",
    "help",
    "lab",
    "lazy",
    "lir",
    "mason",
    "minifiles",
    "ministarter",
    "neo-tree",
    "neogitstatus",
    "neotest-summary",
    "noice",
    "notify",
    "qf",
    "snacks_dashboard",
    "snacks_picker_list",
    "spectre_panel",
    "startify",
    "toggleterm",
  }, vim.api.nvim_get_option_value("filetype", {}))
end

return {
  {
    "nvim-lualine/lualine.nvim",
    firenvim = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "gbprod/nord.nvim",
    },
    config = function(_, opts)
      if #vim.api.nvim_list_uis() == 0 then
        -- Headless mode, don't setup lualine
        return
      end
      require("lualine").setup(opts)
    end,
    opts = function()
      local palette = require("nord.colors").palette
      local icons = require("util.icons")

      local function hide_in_width()
        return vim.o.columns > 100
      end

      local function env_cleanup(venv)
        if string.find(venv, "/") then
          local final_venv = venv
          for w in venv:gmatch("([^/]+)") do
            final_venv = w
          end
          venv = final_venv
        end
        return venv
      end

      local colors = {
        green = palette.aurora.green,
        red = palette.aurora.red,
        yellow = palette.aurora.yellow,
      }

      local function diff_source()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
          return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
          }
        end
      end

      local branch = icons.git.Branch

      local function get_copilot_status()
        local clients = require("util.plugins").is_loaded("copilot.lua")
            and vim.lsp.get_clients({ name = "copilot", bufnr = 0 })
          or {}
        if #clients > 0 then
          local status = require("copilot.api").status.data.status
          return (status == "InProgress" and "pending") or (status == "Warning" and "error") or "ok"
        end
      end

      local copilot_colors = {
        ok = "Special",
        error = "DiagnosticsError",
        pending = "DiagnosticsWarn",
      }

      local components = {
        mode = {
          function()
            return " " .. icons.ui.Target .. " "
          end,
          padding = { left = 0, right = 0 },
          color = {},
          cond = nil,
        },
        branch = {
          "b:gitsigns_head",
          icon = branch,
          color = { gui = "bold" },
        },
        filename = {
          "filename",
          color = {},
          cond = nil,
        },
        diff = {
          "diff",
          source = diff_source,
          symbols = {
            added = icons.git.LineAdded .. " ",
            modified = icons.git.LineModified .. " ",
            removed = icons.git.LineRemoved .. " ",
          },
          padding = { left = 2, right = 1 },
          diff_color = {
            added = { fg = colors.green },
            modified = { fg = colors.yellow },
            removed = { fg = colors.red },
          },
          cond = nil,
        },
        python_env = {
          function()
            if vim.bo.filetype == "python" then
              local venv = os.getenv("CONDA_DEFAULT_ENV") or os.getenv("VIRTUAL_ENV")
              if venv then
                local py_icon, _ = require("nvim-web-devicons").get_icon(".py")
                return string.format(" " .. py_icon .. " (%s)", env_cleanup(venv))
              end
            end
            return ""
          end,
          color = { fg = colors.green },
          cond = hide_in_width,
        },
        copilot = {
          function()
            return " "
          end,
          cond = function()
            return get_copilot_status() ~= nil
          end,
          color = function()
            return { fg = require("snacks").util.color(copilot_colors[get_copilot_status()] or copilot_colors.ok) }
          end,
        },
        diagnostics = {
          "diagnostics",
          sources = { "nvim_diagnostic" },
          symbols = {
            error = icons.diagnostics.BoldError .. " ",
            warn = icons.diagnostics.BoldWarning .. " ",
            info = icons.diagnostics.BoldInformation .. " ",
            hint = icons.diagnostics.BoldHint .. " ",
          },
          -- cond = hide_in_width,
        },
        treesitter = {
          function()
            return icons.ui.Tree
          end,
          color = function()
            local buf = vim.api.nvim_get_current_buf()
            local ts = vim.treesitter.highlighter.active[buf]
            return { fg = ts and not vim.tbl_isempty(ts) and colors.green or colors.red }
          end,
          cond = hide_in_width,
        },
        lsp = {
          function()
            local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
            local buf_client_names = {}

            -- add formatters and linters
            local running_formatters = require("conform").list_formatters_for_buffer(0)
            vim.list_extend(buf_client_names, running_formatters)

            local running_linters = require("lint").get_running(0)
            vim.list_extend(buf_client_names, running_linters)

            if (#buf_clients + #buf_client_names) == 0 then
              return "LSP Inactive"
            end

            -- add client
            for _, client in pairs(buf_clients) do
              if client.name ~= "copilot" then
                table.insert(buf_client_names, client.name)
              end
            end

            local unique_client_names = table.concat(buf_client_names, ", ")
            local language_servers = string.format("[%s]", unique_client_names)

            language_servers = language_servers

            return language_servers
          end,
          color = { gui = "bold" },
          cond = hide_in_width,
        },
        location = { "location" },
        progress = {
          "progress",
          fmt = function()
            return "%P/%L"
          end,
          color = {},
        },

        spaces = {
          function()
            local shiftwidth = vim.api.nvim_get_option_value("shiftwidth", { buf = 0 })
            return icons.ui.Tab .. " " .. shiftwidth
          end,
          padding = 1,
        },
        encoding = {
          "o:encoding",
          fmt = string.upper,
          color = {},
          cond = hide_in_width,
        },
        filetype = { "filetype", cond = nil, padding = { left = 1, right = 1 } },
        scrollbar = {
          function()
            local current_line = vim.fn.line(".")
            local total_lines = vim.fn.line("$")
            local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
            local line_ratio = current_line / total_lines
            local index = math.ceil(line_ratio * #chars)
            return chars[index]
          end,
          padding = { left = 0, right = 0 },
          color = {},
          cond = nil,
        },
      }
      return {
        options = {
          theme = "auto",
          globalstatus = true,
          icons_enabled = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = { "ministarter", "snacks_dashboard", "dap-view", "dap-repl" },
        },
        sections = {
          lualine_a = {
            -- components.mode,
          },
          lualine_b = {
            components.branch,
            "grapple",
          },
          lualine_c = {
            components.diff,
            components.python_env,
          },
          lualine_x = {
            components.diagnostics,
            components.lsp,
            components.copilot,
            components.spaces,
            components.filetype,
          },
          lualine_y = { components.location },
          lualine_z = {
            components.progress,
            components.scrollbar,
          },
        },
        inactive_sections = {
          lualine_a = {
            -- components.mode,
          },
          lualine_b = {
            components.branch,
          },
          lualine_c = {
            components.diff,
            components.python_env,
          },
          lualine_x = {
            components.diagnostics,
            components.lsp,
            components.spaces,
            components.filetype,
          },
          lualine_y = { components.location },
          lualine_z = {
            components.progress,
            components.scrollbar,
          },
        },
        tabline = {
          lualine_a = {
            {
              "filename",
              path = 1,
              newfile_status = true,
              shorting_target = 90,
              cond = not_excluded_filetype,
            },
          },
          lualine_x = {
            -- HACK: Removed `%*` from the end of the grapple-line output so the highlight group is not cut off
            --       which gets rid of an incorrecly highlighted cell
            function()
              return require("grapple-line").lualine():match("^(.*)%%%*$") or ""
            end,
          },
          lualine_z = {
            {
              "tabs",
              cond = function()
                return #vim.api.nvim_list_tabpages() > 1
              end,
            },
          },
        },
        winbar = {
          lualine_a = {
            { require("util.navic").get_winbar, cond = not_excluded_filetype },
          },
        },
        inactive_winbar = {
          lualine_a = {
            { require("util.navic").get_winbar, cond = not_excluded_filetype },
          },
        },
        extensions = {},
      }
    end,
    event = "VeryLazy",
  },
}
