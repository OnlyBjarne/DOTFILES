return {
	"neovim/nvim-lspconfig",
	config = function()
		require("mason").setup()
		require("mason-lspconfig").setup()
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
		vim.lsp.enable "lua_ls"


		vim.lsp.enable "ts_ls"
		vim.lsp.enable "expert"


		vim.lsp.enable "eslint"
		vim.lsp.enable "tailwindcss"




		vim.lsp.enable("pyright")

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
			}, float = {
                    focusable = true,
                    style = 'minimal',
                    border = 'rounded',
                    source = 'always',
                    header = '',
                    prefix = '',
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
