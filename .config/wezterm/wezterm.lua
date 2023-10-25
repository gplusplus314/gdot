local wezterm = require("wezterm")
local act = wezterm.action

local function makeMacKeymap()
	local keymappings = {}
	local function insertRemap(mods_input, mods_output, key)
		table.insert(keymappings, {
			key = key,
			mods = mods_input,
			action = act.SendKey({
				key = key,
				mods = mods_output,
			}),
		})
	end

	local char_keys = "abcdefghijklmnopqrstuvwxyz,./;[]"
	for i = 1, #char_keys do
		local c = char_keys:sub(i, i)
		insertRemap("CMD", "CTRL", c)
		insertRemap("CMD|SHIFT", "CTRL|SHIFT", c)
		insertRemap("CMD|OPT", "CTRL|ALT", c)
		insertRemap("CMD|OPT|SHIFT", "CTRL|ALT|SHIFT", c)
	end

	local function map(entry)
		table.insert(keymappings, entry)
	end

	map({ key = "UpArrow", mods = "CMD", action = act.SendKey({ key = "UpArrow", mods = "CTRL" }) })
	map({ key = "DownArrow", mods = "CMD", action = act.SendKey({ key = "DownArrow", mods = "CTRL" }) })
	map({ key = "LeftArrow", mods = "CMD", action = act.SendKey({ key = "LeftArrow", mods = "CTRL" }) })
	map({ key = "RightArrow", mods = "CMD", action = act.SendKey({ key = "RightArrow", mods = "CTRL" }) })

	map({ key = "v", mods = "SHIFT|CMD", action = act.PasteFrom("Clipboard") })
	map({ key = "c", mods = "SHIFT|CMD", action = act.CopyTo("Clipboard") })
	map({ key = "=", mods = "ALT", action = act.IncreaseFontSize })
	map({ key = "-", mods = "ALT", action = act.DecreaseFontSize })
	map({ key = "1", mods = "ALT", action = act.ActivateTab(0) })
	map({ key = "2", mods = "ALT", action = act.ActivateTab(1) })
	map({ key = "3", mods = "ALT", action = act.ActivateTab(2) })
	map({ key = "4", mods = "ALT", action = act.ActivateTab(3) })
	map({ key = "5", mods = "ALT", action = act.ActivateTab(4) })
	map({ key = "6", mods = "ALT", action = act.ActivateTab(5) })
	map({ key = "7", mods = "ALT", action = act.ActivateTab(6) })
	map({ key = "8", mods = "ALT", action = act.ActivateTab(7) })
	map({ key = "9", mods = "ALT", action = act.ActivateTab(8) })
	map({ key = "0", mods = "ALT", action = act.ActivateTab(9) })
	map({ key = "!", mods = "SHIFT|ALT", action = act.MoveTab(0) })
	map({ key = "@", mods = "SHIFT|ALT", action = act.MoveTab(1) })
	map({ key = "#", mods = "SHIFT|ALT", action = act.MoveTab(2) })
	map({ key = "$", mods = "SHIFT|ALT", action = act.MoveTab(3) })
	map({ key = "%", mods = "SHIFT|ALT", action = act.MoveTab(4) })
	map({ key = "^", mods = "SHIFT|ALT", action = act.MoveTab(5) })
	map({ key = "&", mods = "SHIFT|ALT", action = act.MoveTab(6) })
	map({ key = "*", mods = "SHIFT|ALT", action = act.MoveTab(7) })
	map({ key = "(", mods = "SHIFT|ALT", action = act.MoveTab(8) })
	map({ key = ")", mods = "SHIFT|ALT", action = act.MoveTab(9) })
	map({ key = "t", mods = "ALT", action = act.SpawnTab("CurrentPaneDomain") })

	map({
		key = "f",
		mods = "ALT",
		action = act.QuickSelectArgs({
			patterns = {
				"https?://\\S+",
			},
			label = "open url",
			action = wezterm.action_callback(function(window, pane)
				local url = window:get_selection_text_for_pane(pane)
				wezterm.log_info("opening: " .. url)
				wezterm.open_with(url)
			end),
		}),
	})

	return keymappings
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	if tab.is_active then
		return {
			{ Text = "[ " .. (tab.tab_index + 1) .. ":" .. tab.active_pane.title .. " ]" },
		}
	end
	return {
		{ Text = "  " .. (tab.tab_index + 1) .. ":" .. tab.active_pane.title .. "  " },
	}
end)

return {
	font = wezterm.font_with_fallback({
		"SauceCodePro Nerd Font",
	}),
	keys = makeMacKeymap(),
	font_size = 16.0,
	adjust_window_size_when_changing_font_size = false,
	default_cursor_style = "SteadyBar",
	window_decorations = "RESIZE",
	use_fancy_tab_bar = false,
	tab_bar_at_bottom = true,
	text_background_opacity = 0.75,
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
}
