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

	map({
		key = ".",
		mods = "ALT",
		action = act.ActivateCopyMode,
	})
	map({
		key = "/",
		mods = "ALT",
		action = act.Multiple({
			act.CopyMode("ClearPattern"),
			act.Search({ CaseInSensitiveString = "" }),
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

local function makeKeyTables()
	return {
		copy_mode = {
			{ key = "Tab", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
			{ key = "Tab", mods = "SHIFT", action = act.CopyMode("MoveBackwardWord") },
			{ key = "Enter", mods = "NONE", action = act.CopyMode("MoveToStartOfNextLine") },
			{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
			{ key = "Space", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
			{ key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
			{ key = "$", mods = "SHIFT", action = act.CopyMode("MoveToEndOfLineContent") },
			{ key = ",", mods = "NONE", action = act.CopyMode("JumpReverse") },
			{ key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
			{ key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },
			{ key = "F", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
			{ key = "F", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
			{ key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },
			{ key = "G", mods = "SHIFT", action = act.CopyMode("MoveToScrollbackBottom") },
			{ key = "H", mods = "NONE", action = act.CopyMode("MoveToViewportTop") },
			{ key = "H", mods = "SHIFT", action = act.CopyMode("MoveToViewportTop") },
			{ key = "L", mods = "NONE", action = act.CopyMode("MoveToViewportBottom") },
			{ key = "L", mods = "SHIFT", action = act.CopyMode("MoveToViewportBottom") },
			{ key = "M", mods = "NONE", action = act.CopyMode("MoveToViewportMiddle") },
			{ key = "M", mods = "SHIFT", action = act.CopyMode("MoveToViewportMiddle") },
			{ key = "O", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
			{ key = "O", mods = "SHIFT", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
			{ key = "T", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
			{ key = "T", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
			{ key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
			{ key = "V", mods = "SHIFT", action = act.CopyMode({ SetSelectionMode = "Line" }) },
			{ key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
			{ key = "^", mods = "SHIFT", action = act.CopyMode("MoveToStartOfLineContent") },
			{ key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
			{ key = "b", mods = "ALT", action = act.CopyMode("MoveBackwardWord") },
			{ key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },
			{ key = "c", mods = "CTRL", action = act.CopyMode("Close") },
			{ key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
			{ key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
			{ key = "f", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = false } }) },
			{ key = "f", mods = "ALT", action = act.CopyMode("MoveForwardWord") },
			{ key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
			{ key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
			{ key = "g", mods = "CTRL", action = act.CopyMode("Close") },
			{ key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
			{ key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
			{ key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
			{ key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
			{ key = "m", mods = "ALT", action = act.CopyMode("MoveToStartOfLineContent") },
			{ key = "o", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEnd") },
			{ key = "q", mods = "NONE", action = act.CopyMode("Close") },
			{ key = "t", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = true } }) },
			{ key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
			{ key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
			{ key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
			{ key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
			{
				key = "y",
				mods = "NONE",
				action = act.Multiple({ { CopyTo = "ClipboardAndPrimarySelection" }, { CopyMode = "Close" } }),
			},
			{ key = "PageUp", mods = "NONE", action = act.CopyMode("PageUp") },
			{ key = "PageDown", mods = "NONE", action = act.CopyMode("PageDown") },
			{ key = "End", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
			{ key = "Home", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
			{ key = "LeftArrow", mods = "NONE", action = act.CopyMode("MoveLeft") },
			{ key = "LeftArrow", mods = "ALT", action = act.CopyMode("MoveBackwardWord") },
			{ key = "RightArrow", mods = "NONE", action = act.CopyMode("MoveRight") },
			{ key = "RightArrow", mods = "ALT", action = act.CopyMode("MoveForwardWord") },
			{ key = "UpArrow", mods = "NONE", action = act.CopyMode("MoveUp") },
			{ key = "DownArrow", mods = "NONE", action = act.CopyMode("MoveDown") },
			-- new:
			{ key = "/", mods = "NONE", action = wezterm.action({ Search = { CaseInSensitiveString = "" } }) },
			{ key = "n", mods = "NONE", action = wezterm.action({ CopyMode = "NextMatch" }) },
			{ key = "N", mods = "SHIFT", action = wezterm.action({ CopyMode = "PriorMatch" }) },
			{ key = "u", mods = "NONE", action = act.CopyMode("ClearPattern") },
		},
		search_mode = {
			{ key = "n", mods = "CTRL", action = act.CopyMode("NextMatch") },
			{ key = "p", mods = "CTRL", action = act.CopyMode("PriorMatch") },
			{ key = "r", mods = "CTRL", action = act.CopyMode("CycleMatchType") },
			{ key = "u", mods = "CTRL", action = act.CopyMode("ClearPattern") },
			{ key = "PageUp", mods = "NONE", action = act.CopyMode("PriorMatchPage") },
			{ key = "PageDown", mods = "NONE", action = act.CopyMode("NextMatchPage") },
			{ key = "UpArrow", mods = "NONE", action = act.CopyMode("PriorMatch") },
			{ key = "DownArrow", mods = "NONE", action = act.CopyMode("NextMatch") },
			-- new:
			{ key = "Escape", mods = "NONE", action = wezterm.action({ CopyMode = "Close" }) },
			{ key = "Enter", mods = "NONE", action = act.ActivateCopyMode },
			-- Removed:
			-- { key = "Enter", mods = "NONE", action = act.CopyMode("PriorMatch") },
			-- { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
		},
	}
end

return {
	keys = makeKeymap(),
	key_tables = makeKeyTables(),
}
