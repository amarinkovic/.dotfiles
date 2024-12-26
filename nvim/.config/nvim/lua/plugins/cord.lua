return {
	"vyfor/cord.nvim",
	branch = "client-server",
	build = ":Cord fetch",
	config = function()
		require("cord").setup({
			editor = {
				client = "neovim",
			},
			display = {
				theme = "pastel", -- onyx or pastel
			},
			idle = {
				enabled = true,
				timeout = 300000,
				details = "Thinking 🤔",
			},
			buttons = {
				{
					label = "View Repository",
					url = function(opts)
						if not opts.is_idle then
							return opts.repo_url
						end
					end,
				},
			},
		})
	end,
}
