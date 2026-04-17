return {
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = function()
      local ucolors = require("catppuccin.utils.colors")
      local setup = {
        flavour = "mocha",
        background = { light = "latte", dark = "mocha" },
        term_colors = true,
        transparent_background = true,
        float = {
          transparent = true,
          solid = false,
        },
        integrations = {
          alpha = true,
          barbecue = { dim_dirname = true },
          cmp = true,
          flash = true,
          gitsigns = true,
          harpoon = true,
          illuminate = true,
          indent_blankline = { enabled = true, colored_indent_levels = true },
          lsp_trouble = true,
          lualine = {
            all = function(colors)
              ---@type CtpIntegrationLualineOverride
              return {
                normal = { b = { bg = colors.surface0 } },
                insert = { b = { bg = colors.surface0 } },
                visual = { b = { bg = colors.surface0 } },
                replace = { b = { bg = colors.surface0 } },
                command = { b = { bg = colors.surface0 } },
                inactive = { b = { bg = colors.crust } },
                inactive_insert = { b = { bg = colors.crust } },
                inactive_visual = { b = { bg = colors.crust } },
                inactive_replace = { b = { bg = colors.crust } },
                inactive_command = { b = { bg = colors.crust } },
              }
            end,
          },
          mason = true,
          mini = {
            enabled = true,
            indentscope_color = "",
          },
          navic = { enabled = true, custom_bg = "NONE" },
          neotree = true,
          notify = true,
          neotest = true,
          noice = true,
          symbols_outline = true,
          telescope = true,
          treesitter_context = true,
          which_key = true,
        },
        lsp_styles = {
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        highlight_overrides = {
          mocha = function(mocha)
            return {
              CursorLine = { bg = ucolors.darken(mocha.surface0, 0.64, mocha.base) },
              NeoTreeTabActive = { bg = mocha.mantle },
              NeoTreeTabInactive = { bg = mocha.base },
              NeoTreeTabSeparatorActive = { fg = mocha.mantle, bg = mocha.mantle },
              NeoTreeTabSeparatorInactive = { fg = mocha.base, bg = mocha.base },
              NoiceCmdlineIcon = { style = {} },
              Cursor = { fg = mocha.crust, bg = mocha.sapphire },
              lCursor = { fg = mocha.crust, bg = mocha.sapphire },
              CursorIM = { fg = mocha.crust, bg = mocha.sapphire },
              TermCursor = { fg = mocha.crust, bg = mocha.sapphire },
              NoiceCursor = { fg = mocha.crust, bg = mocha.sapphire },
              NotifyBackground = { bg = mocha.base },
            }
          end,
        },
      }
      return setup
    end,
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
}
