local wezterm = require("wezterm")

local module = {}

-- Define the colors just once
local solarized_colors = {
	-- https://ethanschoonover.com/solarized/#the-values
	ansi = {
		"lab(20% -12 -12)",
		"lab(50%  65  45)",
		"lab(60% -20  65)",
		"lab(60%  10  65)",
		"lab(55% -10 -45)",
		"lab(50%  65 -05)",
		"lab(60% -35 -05)",
		"lab(92% -00  10)",
	},
	brights = {
		"lab(15% -12 -12)",
		"lab(50%  50  55)",
		"lab(45% -07 -07)",
		"lab(50% -07 -07)",
		"lab(60% -06 -03)",
		"lab(50%  15 -45)",
		"lab(65% -05 -02)",
		"lab(97%  00  10)",
	},
}

function module.apply_to_config(config)
	config.color_schemes = {
		-- https://ethanschoonover.com/solarized/#usage-development
		-- No selection_fg since the solarized selection_bg is designed to work without it
		["Canonical Solarized Light"] = {
			foreground = solarized_colors.brights[4],
			background = solarized_colors.brights[8],
			cursor_bg = solarized_colors.brights[3],
			cursor_border = solarized_colors.brights[3],
			cursor_fg = solarized_colors.ansi[8],
			selection_bg = solarized_colors.ansi[8],
			selection_fg = "none",
			split = solarized_colors.brights[3],
		},
		["Canonical Solarized Dark"] = {
			foreground = solarized_colors.brights[5],
			background = solarized_colors.brights[1],
			cursor_bg = solarized_colors.brights[7],
			cursor_border = solarized_colors.brights[7],
			cursor_fg = solarized_colors.ansi[1],
			selection_bg = solarized_colors.ansi[1],
			selection_fg = "none",
			split = solarized_colors.brights[7],
		},
	}

	-- Assign the colors
	config.colors = solarized_colors
	-- Solarized is incompatible with this option
	config.bold_brightens_ansi_colors = "No"
end

return module
