return {
	{
		"neovim/nvim-lspconfig",
		-- event = { "User FileOpened" },
		firenvim = false,
		dependencies = {
			"mason.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"mason-org/mason-lspconfig.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			local servers = {
				bashls = { enable = true, install = true },
				fsautocomplete = { enable = true, install = true },
				hls = { enable = true, install = false },
				jsonls = { enable = true, install = true },
				lua_ls = { enable = true, install = true },
				basedpyright = { enable = true, install = true },
				ruff = { enable = true, install = true },
				taplo = { enable = true, install = true },
				texlab = { enable = true, install = true },
				ts_ls = { enable = true, install = true },
				vimls = { enable = true, install = true },
				volar = { enable = true, install = true },
				yamlls = { enable = true, install = true },
			}
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client == nil then
						return
					end
					if client.name == "ruff" then
						-- Disable hover in favor of Pyright
						client.server_capabilities.hoverProvider = false
					end
				end,
				desc = "LSP: Disable hover capability from Ruff",
			})
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp_attach_navic", { clear = true }),
				callback = function(ev)
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					if
						not (
							vim.api.nvim_get_option_value("filetype", { buf = ev.buf }) == "vue"
              or vim.list_contains({ "copilot", "ruff" }, client.name)
						)
					then
						require("nvim-navic").attach(client, ev.buf)
					end
				end,
			})

			local servers_to_install = vim.tbl_filter(function(key)
				return servers[key].install
			end, vim.tbl_keys(servers))

			require("mason-tool-installer").setup({ ensure_installed = servers_to_install, auto_update = true })

			local servers_to_enable = vim.tbl_filter(function(key)
        if key == "volar" then  -- FIXME: Mason does not recognize vue_ls
          return false
        end
				return servers[key].enable
			end, vim.tbl_keys(servers))
      vim.list_extend(servers_to_enable, { "vue_ls" })

			vim.lsp.config("bashls", { filetypes = { "bash", "sh", "zsh" } })
			vim.lsp.config(
				"ts_ls",
				{ filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" } }
			)

			vim.lsp.enable(servers_to_enable)
		end,
	},
	{
		"mason-org/mason.nvim",
		dependencies = { "mason-org/mason-lspconfig.nvim" },
		firenvim = false,
		opts = {},
		build = function()
			pcall(function()
				require("mason-registry").refresh()
			end)
		end,
		keys = {
			{ "<leader>lm", "<cmd>Mason<cr>", desc = "Mason" },
		},
	},
	{
		"stevearc/conform.nvim",
		firenvim = false,
		config = function()
			local opts = {
				default_format_opts = {
					timeout_ms = 3000,
					async = false, -- not recommended to change
					quiet = false, -- not recommended to change
					lsp_format = "fallback", -- not recommended to change
				},
				formatters = {
					injected = {
						options = {
							ignore_errors = true,
							lang_to_ext = {
								bash = "sh",
								c_sharp = "cs",
								fsharp = "fs",
								javascript = "js",
								latex = "tex",
								markdown = "md",
								python = "py",
							},
						},
					},
					pyupgrade = {
						command = "pyupgrade",
						exit_codes = { 0, 1 },
						stdin = false,
						args = { "$FILENAME" },
						cwd = require("conform.util").root_file({ "pyproject.toml" }),
					},
					kulala = {
						command = "kulala-fmt",
						args = { "format", "$FILENAME" },
						stdin = false,
					},
				},
				formatters_by_ft = {
					fsharp = { "fantomas" },
					graphql = { "prettier" },
					http = { "kulala" },
					json = { "jq" },
					lua = { "stylua" },
					markdown = { "injected" },
					sh = { "beautysh" },
					vue = { "eslint_d" },
					zsh = { "beautysh" },
				},
			}
			require("conform").setup(opts)
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
		cmd = "ConformInfo",
		keys = {
			{
				"<leader>lF",
				function()
					require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
				end,
				mode = { "n", "v" },
				desc = "Format Injected Langs",
			},
			{
				"<leader>lf",
				function()
					local buf = vim.api.nvim_get_current_buf()
					require("conform").format({ bufnr = buf })
				end,
				mode = { "n", "v" },
				desc = "Format",
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		firenvim = false,
		config = function()
			local linters_by_ft = {
				lua = { "stylua" },
				python = { "mypy" },
				vue = { "eslint" },
			}
			local executable_linters = {}
			for filetype, linters in pairs(linters_by_ft) do
				for _, linter in ipairs(linters) do
					if vim.fn.executable(linter) == 1 then
						if executable_linters[filetype] == nil then
							executable_linters[filetype] = {}
						end
						table.insert(executable_linters[filetype], linter)
					end
				end
			end
			require("lint").linters_by_ft = executable_linters
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufRead" }, {
				pattern = { "*.js", "*.py", "*.vue" },
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
		lazy = true,
	},
	{
		"SmiteshP/nvim-navic",
		firenvim = false,
		config = function(_, opts)
			require("nvim-navic").setup(opts)
		end,
		opts = function()
			local function get_icon(kind)
				local icon, _, _ = require("mini.icons").get("lsp", kind)
				return icon .. " "
			end
			return {
				icons = {
					Array = get_icon("Array"),
					Boolean = get_icon("Boolean"),
					Class = get_icon("Class"),
					Color = get_icon("Color"),
					Constant = get_icon("Constant"),
					Constructor = get_icon("Constructor"),
					Enum = get_icon("Enum"),
					EnumMember = get_icon("EnumMember"),
					Event = get_icon("Event"),
					Field = get_icon("Field"),
					File = get_icon("File"),
					Folder = get_icon("Folder"),
					Function = get_icon("Function"),
					Interface = get_icon("Interface"),
					Key = get_icon("Key"),
					Keyword = get_icon("Keyword"),
					Method = get_icon("Method"),
					Module = get_icon("Module"),
					Namespace = get_icon("Namespace"),
					Null = get_icon("Null"),
					Number = get_icon("Number"),
					Object = get_icon("Object"),
					Operator = get_icon("Operator"),
					Package = get_icon("."),
					Property = get_icon("Property"),
					Reference = get_icon("Reference"),
					Snippet = get_icon("Snippet"),
					String = get_icon("String"),
					Struct = get_icon("Struct"),
					Text = get_icon("Text"),
					TypeParameter = get_icon("TypeParameter"),
					Unit = get_icon("Unit"),
					Value = get_icon("Value"),
					Variable = get_icon("Variable"),
				},
				highlight = true,
				separator = " " .. require("util.icons").ui.ChevronRight .. " ",
				depth_limit = 0,
				depth_limit_indicator = "..",
			}
		end,
		event = "User FileOpened",
	},
	{ "justinsgithub/wezterm-types", lazy = true },
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "wezterm-types", modes = { "wezterm" } },
				{ path = "snacks.nvim", words = { "Snacks" } },
			},
		},
	},
	{
		"danymat/neogen",
		firenvim = false,
		opts = {
			snippet_engine = "luasnip",
		},
		keys = {
			{
				"<leader>nc",
				"<cmd>lua require('neogen').generate({ type = 'class' })<cr>",
				desc = "Generate Annotations (Class)",
			},
			{
				"<leader>nf",
				"<cmd>lua require('neogen').generate({ type = 'func' })<cr>",
				desc = "Generate Annotations (Function)",
			},
			{
				"<leader>nt",
				"<cmd>lua require('neogen').generate({ type = 'type' })<cr>",
				desc = "Generate Annotations (Type)",
			},
			{
				"<leader>nF",
				"<cmd>lua require('neogen').generate({ type = 'file' })<cr>",
				desc = "Generate Annotations (File)",
			},
		},
	},
	{
		"davidyz/inlayhint-filler.nvim",
		firenvim = false,
		keys = {
			{
				"<leader>ni",
				function()
					require("inlayhint-filler").fill()
				end,
				mode = { "n", "v" },
				desc = "Insert inlay-hint under cursor",
			},
		},
		event = "LspAttach",
	},
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		firenvim = false,
		priority = 1000,
		opts = {
			preset = "modern",
			hi = {
				mixing_color = "#2E3440",
			},
			options = {
				show_source = true,
			},
		},
		event = "LspAttach",
	},
	{
		"DNLHC/glance.nvim",
		firenvim = false,
		opts = function()
			local ok, nord_glance = pcall(require, "nord.plugins.glance")
			if not ok then
				return {
					border = { enable = true },
				}
			end
			return nord_glance.make_opts({
				folds = {
					folded = false,
				},
			})
		end,
		event = "LspAttach",
		cmd = "Glance",
		keys = {
			{ "<leader>lgd", "<cmd>Glance definitions<cr>", mode = "n", desc = "Glance definitions" },
			{ "<leader>lgr", "<cmd>Glance references<cr>", mode = "n", desc = "Glance references" },
			{ "<leader>lgy", "<cmd>Glance type_definitions<cr>", mode = "n", desc = "Glance type definitions" },
			{ "<leader>lgi", "<cmd>Glance implementations<cr>", mode = "n", desc = "Glance implementations" },
		},
	},
}
