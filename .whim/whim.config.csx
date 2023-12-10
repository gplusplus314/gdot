#nullable enable
#r "C:\Users\g\src\github.com\gplusplus314\Whim\src\Whim.Runner\bin\x64\Release\net7.0-windows10.0.19041.0\whim.dll"
#r "C:\Users\g\src\github.com\gplusplus314\Whim\src\Whim.Runner\bin\x64\Release\net7.0-windows10.0.19041.0\plugins\Whim.Bar\Whim.Bar.dll"
#r "C:\Users\g\src\github.com\gplusplus314\Whim\src\Whim.Runner\bin\x64\Release\net7.0-windows10.0.19041.0\plugins\Whim.CommandPalette\Whim.CommandPalette.dll"
#r "C:\Users\g\src\github.com\gplusplus314\Whim\src\Whim.Runner\bin\x64\Release\net7.0-windows10.0.19041.0\plugins\Whim.FloatingLayout\Whim.FloatingLayout.dll"
#r "C:\Users\g\src\github.com\gplusplus314\Whim\src\Whim.Runner\bin\x64\Release\net7.0-windows10.0.19041.0\plugins\Whim.FocusIndicator\Whim.FocusIndicator.dll"
#r "C:\Users\g\src\github.com\gplusplus314\Whim\src\Whim.Runner\bin\x64\Release\net7.0-windows10.0.19041.0\plugins\Whim.Gaps\Whim.Gaps.dll"
#r "C:\Users\g\src\github.com\gplusplus314\Whim\src\Whim.Runner\bin\x64\Release\net7.0-windows10.0.19041.0\plugins\Whim.LayoutPreview\Whim.LayoutPreview.dll"
#r "C:\Users\g\src\github.com\gplusplus314\Whim\src\Whim.Runner\bin\x64\Release\net7.0-windows10.0.19041.0\plugins\Whim.TreeLayout\Whim.TreeLayout.dll"
#r "C:\Users\g\src\github.com\gplusplus314\Whim\src\Whim.Runner\bin\x64\Release\net7.0-windows10.0.19041.0\plugins\Whim.TreeLayout.Bar\Whim.TreeLayout.Bar.dll"
#r "C:\Users\g\src\github.com\gplusplus314\Whim\src\Whim.Runner\bin\x64\Release\net7.0-windows10.0.19041.0\plugins\Whim.TreeLayout.CommandPalette\Whim.TreeLayout.CommandPalette.dll"

using System;
using System.Collections.Generic;
using System.Linq;
using Whim;
using Whim.Bar;
using Whim.CommandPalette;
using Whim.FloatingLayout;
using Whim.FocusIndicator;
using Whim.Gaps;
using Whim.LayoutPreview;
using Whim.TreeLayout;
using Whim.TreeLayout.Bar;
using Whim.TreeLayout.CommandPalette;
using Windows.Win32.UI.Input.KeyboardAndMouse;
using Microsoft.UI;
using Microsoft.UI.Xaml.Media;

/// <summary>
/// This is what's called when Whim is loaded.
/// </summary>
/// <param name="context"></param>
void DoConfig(IContext context)
{
	context.Logger.Config = new LoggerConfig();

	// Bar plugin.
	List<BarComponent> leftComponents = new() { WorkspaceWidget.CreateComponent() };
	List<BarComponent> centerComponents = new() { FocusedWindowWidget.CreateComponent() };
	List<BarComponent> rightComponents = new()
	{
		DateTimeWidget.CreateComponent(60*1000, "HH:mmt ddd yyyy-MM-dd "),
		ActiveLayoutWidget.CreateComponent(),
	};

	BarConfig barConfig = new(leftComponents, centerComponents, rightComponents);
	barConfig.Height = 24;
	BarPlugin barPlugin = new(context, barConfig);
	context.PluginManager.AddPlugin(barPlugin);

	// Gap plugin.
	GapsConfig gapsConfig = new() { OuterGap = 0, InnerGap = 10 };
	GapsPlugin gapsPlugin = new(context, gapsConfig);
	context.PluginManager.AddPlugin(gapsPlugin);

	// Floating window plugin.
	FloatingLayoutPlugin floatingLayoutPlugin = new(context);
	context.PluginManager.AddPlugin(floatingLayoutPlugin);

	// Focus indicator.
	FocusIndicatorConfig focusIndicatorConfig = new() { 
		Color = new SolidColorBrush(Colors.BlueViolet), 
		FadeEnabled = false,
		BorderSize = 5,
	};
	FocusIndicatorPlugin focusIndicatorPlugin = new(context, focusIndicatorConfig);
	context.PluginManager.AddPlugin(focusIndicatorPlugin);

	// Command palette.
	CommandPaletteConfig commandPaletteConfig = new(context);
	CommandPalettePlugin commandPalettePlugin = new(context, commandPaletteConfig);
	context.PluginManager.AddPlugin(commandPalettePlugin);

	// Tree layout.
	TreeLayoutPlugin treeLayoutPlugin = new(context);
	context.PluginManager.AddPlugin(treeLayoutPlugin);

	// Tree layout bar.
	TreeLayoutBarPlugin treeLayoutBarPlugin = new(treeLayoutPlugin);
	context.PluginManager.AddPlugin(treeLayoutBarPlugin);
	rightComponents.Add(treeLayoutBarPlugin.CreateComponent());

	// Tree layout command palette.
	TreeLayoutCommandPalettePlugin treeLayoutCommandPalettePlugin = new(context, treeLayoutPlugin, commandPalettePlugin);
	context.PluginManager.AddPlugin(treeLayoutCommandPalettePlugin);

	// Layout preview.
	LayoutPreviewPlugin layoutPreviewPlugin = new(context);
	context.PluginManager.AddPlugin(layoutPreviewPlugin);

	context.KeybindManager.Clear();

	// Set up layout engines.
	context.WorkspaceManager.CreateLayoutEngines = () => new CreateLeafLayoutEngine[]
	{
		(id) => new TreeLayoutEngine(context, treeLayoutPlugin, id),
		(id) => new ColumnLayoutEngine(id)
	};
	
	// Set up workspaces.
	const int numWorkspaces = 12;
	for(var i = 1; i <= numWorkspaces; i++) {
		context.WorkspaceManager.Add($"{i}");
		if(i > 10) {
			continue;
		}
		var vk = VIRTUAL_KEY.VK_0 + (ushort)(i%10);
		var idx = i;
		context.KeybindManager.SetKeybind(
			$"whim.core.activate_workspace_{idx}", 
			new Keybind(IKeybind.Win, vk));
		context.CommandManager.Add($"move_window_to_workspace_{idx}", $"Move window to workspace {idx}",
			() => {
				var workspaces = context.WorkspaceManager.ToArray();
				context.WorkspaceManager.MoveWindowToWorkspace(workspaces[idx-1]);
			});
		context.KeybindManager.SetKeybind(
			$"whim.custom.move_window_to_workspace_{idx}", 
			new Keybind(IKeybind.WinShift, vk));
	}
	for(var i = 11; i <= numWorkspaces; i++) {
		var idx = i;
		context.CommandManager.Add($"activate_workspace_{idx}", $"Activate workspace {idx}",
			() => {
				var workspaces = context.WorkspaceManager.ToArray();
				context.WorkspaceManager.Activate(workspaces[idx-1]);
			});
		context.CommandManager.Add($"move_window_to_workspace_{idx}", $"Move window to workspace {idx}",
			() => {
				var workspaces = context.WorkspaceManager.ToArray();
				context.WorkspaceManager.MoveWindowToWorkspace(workspaces[idx-1]);
			});
	}
	context.KeybindManager.SetKeybind("whim.custom.activate_workspace_11",
		new Keybind(IKeybind.Win, VIRTUAL_KEY.VK_OEM_7)); // quote
	context.KeybindManager.SetKeybind("whim.custom.move_window_to_workspace_11",
		new Keybind(IKeybind.WinShift, VIRTUAL_KEY.VK_OEM_7)); // quote
	context.KeybindManager.SetKeybind("whim.custom.activate_workspace_12",
		new Keybind(IKeybind.Win, VIRTUAL_KEY.VK_OEM_5)); // backslash
	context.KeybindManager.SetKeybind("whim.custom.move_window_to_workspace_12",
		new Keybind(IKeybind.WinShift, VIRTUAL_KEY.VK_OEM_5)); // backslash
	
	context.KeybindManager.SetKeybind("whim.core.focus_window_in_direction.left",
		new Keybind(IKeybind.Win, VIRTUAL_KEY.VK_LEFT));
	context.KeybindManager.SetKeybind("whim.core.focus_window_in_direction.right",
		new Keybind(IKeybind.Win, VIRTUAL_KEY.VK_RIGHT));
	context.KeybindManager.SetKeybind("whim.core.focus_window_in_direction.up",
		new Keybind(IKeybind.Win, VIRTUAL_KEY.VK_UP));
	context.KeybindManager.SetKeybind("whim.core.focus_window_in_direction.down",
		new Keybind(IKeybind.Win, VIRTUAL_KEY.VK_DOWN));

	context.KeybindManager.SetKeybind("whim.core.swap_window_in_direction.left",
		new Keybind(IKeybind.WinShift, VIRTUAL_KEY.VK_LEFT));
	context.KeybindManager.SetKeybind("whim.core.swap_window_in_direction.right",
		new Keybind(IKeybind.WinShift, VIRTUAL_KEY.VK_RIGHT));
	context.KeybindManager.SetKeybind("whim.core.swap_window_in_direction.up",
		new Keybind(IKeybind.WinShift, VIRTUAL_KEY.VK_UP));
	context.KeybindManager.SetKeybind("whim.core.swap_window_in_direction.down",
		new Keybind(IKeybind.WinShift, VIRTUAL_KEY.VK_DOWN));
	
	context.KeybindManager.SetKeybind("whim.floating_layout.toggle_window_floating",
		new Keybind(IKeybind.Win, VIRTUAL_KEY.VK_F));

	// Close the in-focus window:
	context.CommandManager.Add("close_focused_window", "close focused window",
		() => context.WorkspaceManager.ActiveWorkspace.LastFocusedWindow.Close() );
	context.KeybindManager.SetKeybind("whim.custom.close_focused_window",
		new Keybind(IKeybind.Win, VIRTUAL_KEY.VK_Q));

	context.KeybindManager.SetKeybind("whim.command_palette.toggle",
		new Keybind(IKeybind.WinShift, VIRTUAL_KEY.VK_P));
}

// We return doConfig here so that Whim can call it when it loads.
return DoConfig;
