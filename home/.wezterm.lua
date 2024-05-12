local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.window_padding = {
    left = 20,
    right = 20,
    top = 20,
    bottom = 20
}

config.window_background_opacity = 0.85
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_rate = 500
config.window_close_confirmation = 'NeverPrompt'
config.window_decorations = 'NONE'
config.enable_tab_bar = false
config.font = wezterm.font_with_fallback { 'undefined', 'JetBrains Mono Nerd Font' }
config.line_height = 0.9
config.font_size = 14.5
config.enable_kitty_graphics = false
config.warn_about_missing_glyphs = false
config.front_end = "WebGpu"

config.color_schemes = {
    ['Kanagawa'] = {
        foreground = '#DCD7BA',
        background = '#1F1F28',
        selection_fg = '#DCD7BA',
        selection_bg = '#223249',
        cursor_bg = '#98BB6C',
        cursor_fg = '#1F1F28',
        cursor_border = '#98BB6C',
    }
}

config.color_scheme = 'Kanagawa'
config.enable_wayland = true

return config
