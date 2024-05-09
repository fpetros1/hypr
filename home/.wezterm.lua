local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.window_padding = {
    left = 20,
    right = 20,
    top = 0,
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
config.font_size = 15
config.enable_kitty_graphics = false
config.warn_about_missing_glyphs = false

config.color_schemes = {
    ['Kanagawa'] = {
        foreground = '#DCD7BA',
        background = '#1F1F28',
        selection_fg = '#DCD7BA',
        selection_bg = '#223249',
        cursor_bg = '#DCD7BA',
        cursor_fg = '#363646',
        cursor_border = '#DCD7BA',
    }
}

config.color_scheme = 'Kanagawa'
config.enable_wayland = true

return config
