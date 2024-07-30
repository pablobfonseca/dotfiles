require("utils.scrollback")

local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font({ family = "MesloLGS Nerd Font Mono", harfbuzz_features = { "calt=0", "clig=0", "liga=0" } })
config.font_size = 16

config.default_cursor_style = "BlinkingBlock"

-- Opacity
-- config.window_background_opacity = 0.9
-- config.macos_window_background_blur = 20

config.animation_fps = 1
config.enable_tab_bar = false
config.window_decorations = "RESIZE"

return config
