local wezterm = require("wezterm")
local config = wezterm.config_builder()

local my_opacity = 0.95

config = {

	color_scheme = "Catppuccin Mocha",

	font = wezterm.font("JetBrains Mono"),

	window_close_confirmation = "NeverPrompt",
	window_background_opacity = my_opacity,

	text_background_opacity = my_opacity,

	hide_tab_bar_if_only_one_tab = true,
	window_padding = {
		left = 0,
		right = 0,
		top = 5,
		bottom = 0,
	},

	initial_rows = 50,
	initial_cols = 200,

	max_fps = 120,

	term = "wezterm",
}

return config
