local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha" -- or Macchiato, Frappe, Latte

config.font = wezterm.font('JetBrains Mono')
-- config.font = wezterm.font('JetBrains Mono', { weight = 'Bold', italic = true })

config.window_close_confirmation = 'NeverPrompt'

-- GUI
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
  left = 0,
  right = 0,
  top = 5,
  bottom = 0,
}
config.initial_rows = 50
config.initial_cols = 200

config.enable_wayland = true

config.term = 'wezterm'


config.keys = {
    { key = 'v', mods = 'CMD|CTRL', action = wezterm.action.PasteFrom 'Clipboard', },
    { key = 'c', mods = 'CMD|CTRL', action = wezterm.action.CopyTo 'Clipboard', },
}


return config
