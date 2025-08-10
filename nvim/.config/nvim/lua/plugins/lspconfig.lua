return {
	"neovim/nvim-lspconfig",
	config = function()
		require("mason").setup()
		vim.lsp.config('lua_ls', {
			settings = {
				Lua = {
					runtime = { version = 'Lua 5.1' },
					diagnostics = {
						globals = { 'bit', 'vim', 'it', 'describe', 'before_each', 'after_each' },
					},
				},
			},
		})

		local vue_ls_path = vim.fn.expand("$MASON/packages/vue-language-server")
		local vue_plugin_path = vue_ls_path .. "/node_modules/@vue/language-server"

		-- Now configure ts_ls (TypeScript) to load the Vue plugin
		require("lspconfig").ts_ls.setup({
			init_options = {
				plugins = {
					{
						name = "@vue/typescript-plugin",
						location = vue_plugin_path,
						languages = { "vue" },
					},
				},
			},
			filetypes = { "typescript", "javascript", "vue" },
		})

		require("lspconfig").tailwindcss.setup {
			init_options = {
			  filetypes = {"svelte", "vue", "html"}
			}

		}

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
		{ "mason-org/mason-lspconfig.nvim", version = "^2.0.0" },
		{ "mason-org/mason.nvim",           version = "^2.0.0" },
		{ "saghen/blink.cmp",               build = "cargo build --release" },
	},
}
