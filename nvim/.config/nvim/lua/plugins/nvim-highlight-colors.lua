return {
	"brenoprata10/nvim-highlight-colors",
	config = function()
		require("nvim-highlight-colors").setup({})

		require("cmp").setup({
			formatting = {
				format = require("nvim-highlight-colors").format,
			},
		})
	end,
}
