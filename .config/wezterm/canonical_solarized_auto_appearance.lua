local wezterm = require("wezterm")

local module = {}

-- https://wezfurlong.org/wezterm/config/lua/wezterm.gui/get_appearance.html#wayland-gnome-appearance
-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return "Light"
end

function scheme_for_appearance(appearance)
  if appearance:find("Light") then
    return "Canonical Solarized Light"
  else
    return "Canonical Solarized Dark"
  end
end

function module.apply_to_config(config)
  config.color_scheme = scheme_for_appearance(get_appearance())
end

return module
