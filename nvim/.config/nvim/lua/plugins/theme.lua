return { -- You can easily change to a different colorscheme.
	"catppuccin/nvim",
	name = "catppuccin",
	version = "v1.10.0",
	priority = 1000, -- Make sure to load this before all the other start plugins.
	init = function()
		vim.cmd.colorscheme("catppuccin-frappe")
		-- vim.cmd.hi("Comment gui=none")
	end,
}
