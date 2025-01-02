return {
	"brenoprata10/nvim-highlight-colors",
	config = function()
		-- Ensure termguicolors is enabled if not already
		vim.opt.termguicolors = true

		require("nvim-highlight-colors").setup({})

		require("cmp").setup({
			formatting = {
				format = require("nvim-highlight-colors").format,
			},
		})
	end,
}
