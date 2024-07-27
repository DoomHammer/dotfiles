local wezterm = require("wezterm")
local config = {}

-- Nice and readable
config.font = wezterm.font("Iosevka Nerd Font Mono")
config.font_size = 14

-- I have tmux already
config.enable_tab_bar = false

-- I don't like my terminal making noise
config.audible_bell = "Disabled"

-- Best of both worlds (iTerm2 and Kitty graphics)
config.enable_kitty_graphics = true

-- From https://github.com/gfguthrie/wezterm-canonical-solarized
local canonical_solarized = require("canonical_solarized")
canonical_solarized.apply_to_config(config)

-- Possible alternative: https://wezfurlong.org/wezterm/colorschemes/s/index.html#solarized-light-gogh
-- config.color_scheme = "Canonical Solarized Light"

local canonical_solarized_auto_appearance = require("canonical_solarized_auto_appearance")
canonical_solarized_auto_appearance.apply_to_config(config)

return config
