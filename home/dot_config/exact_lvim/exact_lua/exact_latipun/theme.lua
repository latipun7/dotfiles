local M = {}
local colors = require("catppuccin.palettes").get_palette()

M.current_colors = function()
  return {
    rosewater = colors.rosewater,
    flamingo = colors.flamingo,
    violet = colors.mauve,
    pink = colors.pink,
    red = colors.red,
    maroon = colors.maroon,
    orange = colors.peach,
    yellow = colors.yellow,
    green = colors.green,
    blue = colors.blue,
    cyan = colors.sky,
    teal = colors.teal,
    sapphire = colors.sapphire,
    lavender = colors.lavender,
    white = colors.text,
    gray2 = colors.overlay2,
    gray1 = colors.overlay1,
    gray0 = colors.overlay0,
    black4 = colors.surface1,
    bg_br = colors.surface0,
    bg = colors.mantle,
    bg_alt = colors.base,
    fg = colors.text,
    black = colors.mantle,
    git = {
      add = colors.green,
      change = colors.blue,
      delete = colors.red,
      conflict = colors.peach,
    },
  }
end

return M
