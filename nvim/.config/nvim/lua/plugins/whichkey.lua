return {
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			spec = {
				{ "<leader>f", group = "[F]ind" }, -- group
				{ "<leader>d", group = "[D]ocument" }, -- group
				{ "<leader>w", group = "[W]orkspace" }, -- group
				{ "<leader>l", group = "[L]sp" }, -- group
			},
			-- 	defaults = { prefix = "<leader>" }, -- You can also set global defaults here
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	}
