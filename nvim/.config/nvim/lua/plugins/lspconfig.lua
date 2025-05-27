return {
	"neovim/nvim-lspconfig",
	config = function()
		require("mason").setup()

		local servers = {
			ts_ls = {
				init_options = {
					plugins = {
						{
							name = "@vue/typescript-plugin",
							location = vim.fn.expand(
								"$MASON/packages/vue-language-server/node_modules/@vue/language-server"
							),
							languages = { "vue" },
						},
					},
				},
			},
			volar = {
				init_options = {
					vue = {
						hybridMode = false,
					},
				},
			},
		}

		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"stylua", -- Used to format Lua code
		})

		local capabilities = require("blink.cmp").get_lsp_capabilities()

		require("mason-lspconfig").setup({
			automatic_installation = false,
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					-- This handles overriding only values explicitly passed
					-- by the server configuration above. Useful when disabling
					-- certain features of an LSP (for example, turning off formatting for ts_ls)
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})

		require("blink.cmp").setup({
			completion = {
				documentation = { auto_show = true },
			},
			keymap = { preset = "enter" },
		})

		vim.diagnostic.config({
			signs = {
				numhl = {
					[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
					[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
					[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
					[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
				},
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.HINT] = "",
					[vim.diagnostic.severity.INFO] = "",
					[vim.diagnostic.severity.WARN] = "",
				},
			},
			update_in_insert = true,
			virtual_text = true,
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
			callback = function(ev)
				local opts = { buffer = ev.buf }
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "<space>lr", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "<space>lf", function()
					vim.lsp.buf.format({ async = true })
				end, opts)

				vim.keymap.set("n", "<space>lh", function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
				end, opts)
				vim.keymap.set("n", "<space>la", vim.lsp.buf.code_action, opts)
			end,
		})
	end,
	dependencies = {
		"rafamadriz/friendly-snippets",
		{ "mason-org/mason-lspconfig.nvim", version = "^1.0.0" },
		{ "mason-org/mason.nvim", version = "^1.0.0" },
		{ "saghen/blink.cmp", build = "cargo build --release" },
	},
}
