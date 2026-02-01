local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ───────────────────────────────
-- Font & Appearance
-- ───────────────────────────────
config.font = wezterm.font("Monaco")
config.font_size = 12.5

config.window_background_opacity = 0.6
config.scrollback_lines = 13500
config.use_ime = false

config.colors = {
  foreground = "#fcfcfa",
  background = "#000000",

  cursor_bg = "#fcfcfa",
  cursor_border = "#fcfcfa",
  cursor_fg = "#000000",

  selection_fg = "#403e41",
  selection_bg = "#fcfcfa",

  ansi = {
    "#403e41", -- black
    "#ff6188", -- red
    "#a9dc76", -- green
    "#ffd866", -- yellow
    "#fc9867", -- blue
    "#ab9df2", -- magenta
    "#78dce8", -- cyan
    "#fcfcfa", -- white
  },
  brights = {
    "#727072", -- bright black
    "#ff6188", -- bright red
    "#a9dc76", -- bright green
    "#ffd866", -- bright yellow
    "#fc9867", -- bright blue
    "#ab9df2", -- bright magenta
    "#78dce8", -- bright cyan
    "#fcfcfa", -- bright white
  },
}

--config.window_decorations = "RESIZE"
--config.window_padding = { left = 4, right = 4, top = 4, bottom = 4 }

-- ───────────────────────────────
-- Workspaces (mux)
-- ───────────────────────────────
config.default_workspace = "home"

-- Show current workspace in the status bar
wezterm.on("update-right-status", function(window, _)
  local ws = window:active_workspace()
  window:set_right_status((" 󰘔 %s "):format(ws))
end)

-- ───────────────────────────────
-- Keybindings
-- ───────────────────────────────
config.keys = {
  { key = "Enter", mods = "SHIFT", action = wezterm.action { SendString = "\x1b\r" } },

  -- Fuzzy workspace switcher
  {
    key = "p",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ShowLauncherArgs {
      flags = "FUZZY|WORKSPACES|LAUNCH_MENU_ITEMS",
    },
  },

  -- Quick return to home workspace
  {
    key = "w",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SwitchToWorkspace { name = "home" },
  },
}

-- Optional: make new windows reuse current workspace
wezterm.on("gui-startup", function(cmd)
  local mux = wezterm.mux
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return config

