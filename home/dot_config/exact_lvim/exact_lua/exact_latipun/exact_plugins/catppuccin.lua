local M = {}

M.config = function()
  local status_ok, catppuccin = pcall(require, "catppuccin")
  if not status_ok then return end

  local ucolors = require("catppuccin.utils.colors")

  catppuccin.setup({
    flavour = "mocha",
    background = { light = "latte", dark = "mocha" },
    term_colors = true,
    transparent_background = lvim.transparent_window,
    integrations = {
      cmp = true,
      gitsigns = true,
      harpoon = true,
      hop = true,
      illuminate = true,
      indent_blankline = { enabled = true, colored_indent_levels = true },
      mason = true,
      navic = { enabled = true, custom_bg = "NONE" },
      neotree = true,
      notify = true,
      symbols_outline = true,
      telescope = true,
      treesitter = true,
      which_key = true,
    },
    highlight_overrides = {
      mocha = function(mocha)
        return {
          CursorLine = { bg = ucolors.darken(mocha.surface0, 0.64, mocha.base) },
          NeoTreeTabActive = { bg = mocha.mantle },
          NeoTreeTabInactive = { bg = mocha.base },
          NeoTreeTabSeparatorActive = { fg = mocha.mantle, bg = mocha.mantle },
          NeoTreeTabSeparatorInactive = { fg = mocha.base, bg = mocha.base },
          Cursor = { fg = mocha.crust, bg = mocha.sapphire },
          lCursor = { fg = mocha.crust, bg = mocha.sapphire },
          CursorIM = { fg = mocha.crust, bg = mocha.sapphire },
          TermCursor = { fg = mocha.crust, bg = mocha.sapphire },
          NoiceCursor = { fg = mocha.crust, bg = mocha.sapphire },
        }
      end,
    },
  })
end

return M
