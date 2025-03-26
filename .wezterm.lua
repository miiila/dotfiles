local wezterm = require 'wezterm'

return {
  -- Font settings
  font = wezterm.font("Monaco"),
  --font = wezterm.font("JetBrains Mono"),
  font_size = 12.5,

  -- Transparency
  window_background_opacity = 0.6,

  -- Colors
  colors = {
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
  },

  -- Disable fancy text composition (similar to legacy strategy)
  use_ime = false,
  --front_end = "WebGpu"
}

