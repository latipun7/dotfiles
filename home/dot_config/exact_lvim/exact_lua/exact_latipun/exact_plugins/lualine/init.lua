local M = {}
local components = require("latipun.plugins.lualine.components")

M.config = function()
  local config = {
    options = {
      icons_enabled = true,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      theme = "catppuccin",
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
        components.python_env,
        components.testing,
        components.session,
        components.auto_format,
      },
      lualine_x = {
        components.readonly,
        components.diagnostic,
        components.treesitter,
        components.lsp_status,
      },
      lualine_y = {
        components.location,
        components.filesize,
        components.fileformat,
      },
      lualine_z = { components.scrollbar },
    },

    inactive_sections = {
      lualine_a = { "filename" },
      lualine_v = {},
      lualine_y = {},
      lualine_z = {},
      lualine_c = {},
      lualine_x = {},
    },
  }

  -- initialize lualine in lvim
  lvim.builtin.lualine.options = config.options
  lvim.builtin.lualine.sections = config.sections
  lvim.builtin.lualine.inactive_sections = config.inactive_sections
  lvim.builtin.lualine.extensions = {}
end

return M
