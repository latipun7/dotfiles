return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local ok, catppuccin = pcall(require, "lualine.themes.catppuccin")
      if not ok then return opts end

      local components = require("plugins.lualine.components")
      local colors = require("catppuccin.palettes").get_palette()

      if colors ~= nil then
        catppuccin.normal.b.bg = colors.surface0
        catppuccin.insert.b.bg = colors.surface0
        catppuccin.command.b.bg = colors.surface0
        catppuccin.visual.b.bg = colors.surface0
        catppuccin.replace.b.bg = colors.surface0
      end

      local config = {
        options = {
          icons_enabled = true,
          component_separators = "",
          section_separators = { left = "", right = "" },
          theme = catppuccin,
          disabled_filetypes = { "dashboard", "alpha" },
          ignore_focus = { "NvimTree", "neo-tree" },
          always_divide_middle = true,
          globalstatus = true,
        },
        extensions = { "lazy" },
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
            components.session,
            components.treesitter,
            components.auto_format,
          },
          lualine_x = {
            components.showmode,
            components.dap_status,
            components.lazy_status,
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
      return config
    end,
  },
}
