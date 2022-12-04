---@meta

local b = require("beautiful")

---@class beautiful.core
local x = {
  init = b.init,
  get = b.get,
  get_font = b.get_font,
  get_font_height = b.get_font_height,
  get_merged_font = b.get_merged_font,
  gtk = b.gtk,
  theme_assets = b.theme_assets,
  xresources = b.xresources,
}

---@type beautiful.core|beautiful.theme
local M

return M
