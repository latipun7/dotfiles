local M = {}

local colors = {}

local ok, catppuccin = pcall(require, "catppuccin.palettes")
if ok then
  colors = catppuccin.get_palette()
else
  colors = {
    rosewater = "#ffffff",
    flamingo = "#ffffff",
    mauve = "#ffffff",
    pink = "#ffffff",
    red = "#ffffff",
    maroon = "#ffffff",
    peach = "#ffffff",
    yellow = "#ffffff",
    green = "#ffffff",
    blue = "#ffffff",
    sky = "#ffffff",
    teal = "#ffffff",
    sapphire = "#ffffff",
    lavender = "#ffffff",
    text = "#ffffff",
    overlay2 = "#ffffff",
    overlay1 = "#ffffff",
    overlay0 = "#ffffff",
    surface1 = "#ffffff",
    surface0 = "#ffffff",
    mantle = "#ffffff",
    base = "#ffffff",
    crust = "#ffffff",
  }
end

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
    black = colors.surface1,
    bg_br = colors.surface0,
    bg = colors.mantle,
    bg_alt = colors.base,
    fg = colors.text,
    dark = colors.crust,
    git = {
      add = colors.green,
      change = colors.blue,
      delete = colors.red,
      conflict = colors.peach,
    },
  }
end

return M
