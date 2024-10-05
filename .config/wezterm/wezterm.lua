local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- カラースキームの設定
config.color_scheme = 'AdventureTime'
config.window_background_opacity = 0.80
config.macos_window_background_blur = 20
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.show_tabs_in_tab_bar = true

config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}
 config.window_background_gradient = {
   colors = { "#000000" },
 }
 config.colors = {
   tab_bar = {
     inactive_tab_edge = "none",
   },
 }
 wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
   local background = "#000000"
   local foreground = "#FFFFFF"

   if tab.is_active then
     background = "#FFB454"
     foreground = "#000000"
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
