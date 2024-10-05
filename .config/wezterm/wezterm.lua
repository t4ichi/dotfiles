local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

local mux = wezterm.mux
wezterm.on('gui-startup', function(cmd)
  mux.spawn_window(cmd or {width=156, height=46})
end)

config.automatically_reload_config = false
config.color_scheme = 'Ayu Dark (Gogh)'
config.window_background_opacity = 0.70
config.macos_window_background_blur = 20
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.show_tabs_in_tab_bar = true

config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}

 config.window_background_gradient = {
   colors = { "#0D1017" },
 }

config.show_new_tab_button_in_tab_bar = false
config.use_fancy_tab_bar = false

 config.colors = {
   tab_bar = {
     inactive_tab_edge = "none",
   },
 }

wezterm.on("format-tab-title", function(tab,max_width)
  local background = "#0D1017"
  local foreground = "#565B66"
  if tab.is_active then
    background = "#FFB454"
    foreground = "#0D1017"
  end
  local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "
  return {
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
  }
end)

config.keys = {
}

config.mouse_bindings = {
    -- 右クリックでクリップボードから貼り付け
    {
        event = { Down = { streak = 1, button = 'Right' } },
        mods = 'NONE',
        action = wezterm.action.PasteFrom 'Clipboard',
    },
}

return config
