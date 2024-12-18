-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha" -- or Macchiato, Frappe, Latte

config.font = wezterm.font('JetBrains Mono')
-- config.font = wezterm.font('JetBrains Mono', { weight = 'Bold', italic = true })

return config
