return {
	"vyfor/cord.nvim",
	build = "./build || .\\build",
	event = "VeryLazy",
	opts = {
 		usercmds = true,
		editor = {
			client = "neovim",
			tooltip = "Neovim The Superior Text Editor",
		},
		display = {
			theme = "pastel", -- onyx or pastel
			show_repository = true, -- Display 'View repository' button linked to repository url, if any
		},
		lsp = {
			show_problem_count = true, -- Display number of diagnostics problems
			severity = 1, -- 1 = Error, 2 = Warning, 3 = Info, 4 = Hint
			scope = "workspace", -- buffer or workspace
		},
		idle = {
			enabled = true,
			timeout = 300000,
			details = "Thinking 🤔",
		},
		buttons = {
			{ label = "View Repository", url = "git" },
			{ label = "My Github", url = "https://github.com/amarinkovic" },
		},
	},
}
