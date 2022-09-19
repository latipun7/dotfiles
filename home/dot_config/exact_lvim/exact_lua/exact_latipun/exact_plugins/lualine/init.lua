local M = {}
local components = require("latipun.plugins.lualine.components")
local catppuccino = require("lualine.themes.catppuccin")
local colors = require("latipun.theme").current_colors()

catppuccino.normal.b.bg = colors.bg_br
catppuccino.insert.b.bg = colors.bg_br
catppuccino.command.b.bg = colors.bg_br
catppuccino.visual.b.bg = colors.bg_br
catppuccino.replace.b.bg = colors.bg_br

M.config = function()
  local config = {
    options = {
      icons_enabled = true,
      component_separators = "",
      section_separators = { left = "", right = "" },
      theme = catppuccino,
      disabled_filetypes = {
        "dashboard",
        "Outline",
        "alpha",
        "vista",
        "vista_kind",
        "TelescopePrompt",
      },
      ignore_focus = { "NvimTree" },
      always_divide_middle = true,
      globalstatus = lvim.builtin.global_statusline,
    },

    sections = {
      lualine_a = { components.mode, components.git_branch },
      lualine_b = {
        components.win_icon,
        components.filetype,
        components.filename,
        components.diff,
      },
      lualine_c = {
        components.readonly,
        components.testing,
        components.session,
        components.auto_format,
        components.treesitter,
      },
      lualine_x = {
        components.python_env,
        components.diagnostic,
        components.lsp_status,
      },
      lualine_y = {
        components.location,
        components.filesize,
        components.fileformat,
      },
      lualine_z = { components.progress, components.scrollbar },
    },

    inactive_sections = {
      lualine_a = {},
      lualine_b = { "filename" },
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
  }

  -- initialize lualine in lvim
  lvim.builtin.lualine.options = config.options
  lvim.builtin.lualine.sections = config.sections
  lvim.builtin.lualine.inactive_sections = config.inactive_sections
  lvim.builtin.lualine.extensions = {}
end

return M
