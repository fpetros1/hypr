local wezterm = require 'wezterm'

function OS_config()
    local os = Get_os()

    if os == "GNU/Linux" then
        return Linux_config()
    end

    if os == "Darwin" then
        return Mac_config()
    end

    return wezterm.config_builder()
end

function Get_os()
    local osname = "Windows"
    local fh, _ = assert(io.popen("uname -o 2>/dev/null", "r"))
    if fh then
        osname = fh:read()
    end

    return osname
end

function Linux_config()
    local config = wezterm.config_builder()
    local mux = wezterm.mux

    config.window_padding = {
        left = 20,
        right = 20,
        top = 20,
        bottom = 20
    }

    config.window_background_opacity = 0.95
    config.default_cursor_style = 'BlinkingBlock'
    config.cursor_blink_rate = 500
    config.window_close_confirmation = 'NeverPrompt'
    config.enable_tab_bar = false
    config.font = wezterm.font {
        family = 'FiraCode Nerd Font Mono',
        weight = 'Regular'
    }
    config.line_height = 1.2
    config.font_size = 12
    config.enable_kitty_graphics = false
    config.warn_about_missing_glyphs = false
    config.front_end = "WebGpu"
    config.term = "xterm-256color"
    config.color_scheme = 'Kanagawa (Gogh)'
    config.enable_wayland = false
    config.max_fps = 165
    config.animation_fps = 165

    wezterm.on('gui-attached', function()
        local workspace = mux.get_active_workspace()
        for _, window in ipairs(mux.all_windows()) do
            if window:get_workspace() == workspace then
                window:gui_window():maximize()
            end
        end
    end)

    return config
end

function Mac_config()
    local config = wezterm.config_builder()
    local mux = wezterm.mux

    config.window_padding = {
        left = 20,
        right = 20,
        top = 20,
        bottom = 20
    }

    config.window_background_opacity = 0.95
    config.default_cursor_style = 'BlinkingBlock'
    config.cursor_blink_rate = 500
    config.window_close_confirmation = 'NeverPrompt'
    config.enable_tab_bar = false
    config.font = wezterm.font {
        family = 'FiraCode Nerd Font Mono',
        weight = 'Regular'
    }
    config.line_height = 1.2
    config.font_size = 15
    config.enable_kitty_graphics = false
    config.warn_about_missing_glyphs = false
    config.front_end = "WebGpu"
    config.term = "xterm-256color"
    config.color_scheme = 'Kanagawa (Gogh)'
    config.max_fps = 165
    config.animation_fps = 165

    config.set_environment_variables = {
        PATH = '/usr/local/bin/:' .. os.getenv('PATH')
    }

    wezterm.on('gui-attached', function()
        local workspace = mux.get_active_workspace()
        for _, window in ipairs(mux.all_windows()) do
            if window:get_workspace() == workspace then
                window:gui_window():maximize()
            end
        end
    end)

    return config
end

return OS_config()
