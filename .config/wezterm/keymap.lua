local wezterm = require("wezterm")
local act = wezterm.action

local function makeMacKeymap(keymappings)
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
end

local function makeWinLinuxKeymap(keymappings)
	local function map(entry)
		table.insert(keymappings, entry)
	end

	map({ key = "UpArrow", mods = "CTRL", action = act.SendKey({ key = "UpArrow", mods = "CTRL" }) })
	map({ key = "DownArrow", mods = "CTRL", action = act.SendKey({ key = "DownArrow", mods = "CTRL" }) })
	map({ key = "LeftArrow", mods = "CTRL", action = act.SendKey({ key = "LeftArrow", mods = "CTRL" }) })
	map({ key = "RightArrow", mods = "CTRL", action = act.SendKey({ key = "RightArrow", mods = "CTRL" }) })

	map({ key = "v", mods = "SHIFT|CTRL", action = act.PasteFrom("Clipboard") })
	map({ key = "c", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") })
end

local function makeCommonKeymap(keymappings)
	local function map(entry)
		table.insert(keymappings, entry)
	end

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
		key = "Space",
		mods = "ALT",
		action = act.ShowLauncherArgs({
			flags = "FUZZY|TABS|DOMAINS|KEY_ASSIGNMENTS|WORKSPACES|COMMANDS",
			title = "#",
		}),
	})
	map({
		key = "o",
		mods = "ALT",
		action = act.ShowLauncherArgs({
			flags = "FUZZY|LAUNCH_MENU_ITEMS",
			title = "#",
		}),
	})

	map({
		key = "r",
		mods = "ALT",
		action = act.PromptInputLine({
			description = "Rename tab",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	})

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
end

local function makeKeymap()
	local keymappings = {}
	if string.find(wezterm.target_triple, "apple") then
		makeMacKeymap(keymappings)
	else
		makeWinLinuxKeymap(keymappings)
	end
	makeCommonKeymap(keymappings)
	return keymappings
end

return makeKeymap()
