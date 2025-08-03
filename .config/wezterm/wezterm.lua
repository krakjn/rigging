-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.font = wezterm.font("0xProto Nerd Font Mono")
config.default_cursor_style = "BlinkingBlock"

-- For example, changing the color scheme:
-- config.color_scheme = "AdventureTime"
config.color_scheme = "Everforest Dark Hard (Gogh)"
config.window_background_opacity = 0.80

-- Add keybindings for spawning new panes and navigating between them
config.keys = {
	-- Command + Enter to spawn a new vertical pane
	{
		key = "Enter",
		mods = "CMD",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	-- Command + Shift + Enter to spawn a new horizontal pane
	{
		key = "Enter",
		mods = "CMD|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},

	-- Vim-like navigation for panes
	{
		key = "j",
		mods = "ALT",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "ALT",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "h",
		mods = "ALT",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = "ALT",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	-- ALT + T to toggle pane zoom state
	{
		key = "f",
		mods = "ALT",
		action = wezterm.action.TogglePaneZoomState,
	},

	-- ALT + SHIFT + L to toggle pane layout (swap panes)
	{
		key = "l",
		mods = "ALT|SHIFT",
		action = wezterm.action.PaneSelect({ mode = "SwapWithActive" }),
	},
}
-- and finally, return the configuration to wezterm
return config
