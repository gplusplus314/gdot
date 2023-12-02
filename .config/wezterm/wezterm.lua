local wezterm = require("wezterm")
local launch_menu = require("launch_menu")

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = tab.get_title()
	if title == nil then
		title = tab.active_pane.title
	end
	if tab.is_active then
		return {
			{ Text = "[ " .. (tab.tab_index + 1) .. ":" .. title .. " ]" },
		}
	end
	return {
		{ Text = "  " .. (tab.tab_index + 1) .. ":" .. title .. "  " },
	}
end)

return {
	font = wezterm.font_with_fallback({
		"SauceCodePro Nerd Font",
	}),
	keys = require("keymap"),
	font_size = 12.0,
	adjust_window_size_when_changing_font_size = false,
	default_cursor_style = "SteadyBar",
	window_decorations = "RESIZE",
	use_fancy_tab_bar = false,
	tab_bar_at_bottom = true,
	tab_max_width = 32,
	text_background_opacity = 1,
	colors = {
		-- #080812
		background = "rgba(8, 8, 18, 0.75)",
		tab_bar = {
			background = "#000000",
			active_tab = {
				bg_color = "#181818",
				fg_color = "#6060ff",
				intensity = "Bold",
			},
			inactive_tab = {
				bg_color = "#000000",
				fg_color = "#777777",
				intensity = "Bold",
			},
			new_tab = {
				bg_color = "#000000",
				fg_color = "#000000",
			},
			new_tab_hover = {
				bg_color = "#000000",
				fg_color = "#000000",
				italic = true,
			},
		},
	},
	launch_menu = launch_menu.get(),
}
