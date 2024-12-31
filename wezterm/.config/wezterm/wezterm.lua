-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config = {

  -- color_scheme = "Catppuccin Mocha", -- or Macchiato, Frappe, Latte
  -- color_scheme = "Tokyo Night",

  font = wezterm.font('JetBrains Mono'),

  window_close_confirmation = 'NeverPrompt',

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

  term = 'wezterm',
}

-- return the configuration to wezterm
return config
