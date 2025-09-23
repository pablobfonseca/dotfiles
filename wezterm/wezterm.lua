require("utils.scrollback")

local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "tokyonight_night"
config.font = wezterm.font({ family = "IosevkaTerm Nerd Font" })
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.font_size = 17
config.automatically_reload_config = true
config.max_fps = 120
config.enable_kitty_graphics = true
config.window_close_confirmation = "NeverPrompt"

config.audible_bell = "Disabled"

config.default_cursor_style = "BlinkingBlock"

-- Opacity
-- config.window_background_opacity = 0.9
-- config.macos_window_background_blur = 20

config.animation_fps = 1
config.enable_tab_bar = false
config.window_decorations = "RESIZE"

return config
