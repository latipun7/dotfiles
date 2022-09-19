local functions = require("latipun.plugins.lualine.functions")
local conditions = require("latipun.plugins.lualine.conditions")
local colors = require("latipun.theme").current_colors()
local kind = require("latipun.lsp_kind")

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

local function get_file_icon_color()
  local f_name, f_ext = vim.fn.expand("%:t"), vim.fn.expand("%:e")
  local has_devicons, devicons = pcall(require, "nvim-web-devicons")
  if has_devicons then
    local icon, iconhl = devicons.get_icon(f_name, f_ext)
    if icon ~= nil then
      return vim.fn.synIDattr(vim.fn.hlID(iconhl), "fg")
    end
  end
end

local components = {
  mode = { functions.mode },

  git_branch = {
    "b:gitsigns_head",
    icon = "",
    padding = { left = 0, right = 1 },
    cond = conditions.is_git_workspace,
  },

  win_icon = {
    functions.win_icon,
    cond = conditions.not_empty_buffer,
    color = function()
      return { fg = get_file_icon_color() }
    end,
    padding = { left = 1, right = 0 },
  },

  filetype = {
    "filetype",
    colored = true,
    icon_only = true,
    padding = { left = 1, right = 0 },
  },

  filename = {
    functions.filename,
    cond = conditions.not_empty_buffer,
    color = { fg = colors.fg },
    separator = "",
  },

  diff = {
    "diff",
    source = diff_source,
    cond = conditions.is_git_workspace and conditions.is_in_width_limit,
    symbols = { added = " ", modified = " ", removed = " " },
  },

  readonly = {
    functions.readonly,
    color = { fg = colors.red },
    padding = { left = 1, right = 0 },
  },

  testing = {
    functions.testing,
    cond = function()
      return functions.testing() ~= nil
    end,
    padding = { left = 1, right = 0 },
  },

  session = {
    functions.session,
    color = { fg = colors.flamingo },
    cond = function()
      return (vim.g.persisting ~= nil)
    end,
    padding = { left = 1, right = 0 },
  },

  auto_format = {
    functions.auto_format,
    color = { fg = colors.sapphire },
    padding = { left = 1, right = 0 },
  },

  treesitter = {
    functions.treesitter,
    color = { fg = colors.green },
  },

  python_env = {
    functions.python_env,
    color = { fg = colors.green },
    cond = conditions.is_large_width,
    separator = "",
  },

  diagnostic = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = {
      error = kind.icons.error .. " ",
      warn = kind.icons.warn .. " ",
      info = kind.icons.info .. " ",
      hint = kind.icons.hint .. " ",
    },
    cond = conditions.is_in_width_limit,
    separator = "",
  },

  lsp_status = {
    functions.lsp_status,
    color = { fg = colors.fg },
    cond = conditions.is_in_width_limit,
  },

  location = {
    "location",
    color = { fg = colors.orange },
    cond = conditions.not_empty_buffer,
  },

  filesize = {
    functions.filesize,
    cond = conditions.not_empty_buffer,
    color = { fg = colors.sapphire },
    padding = { left = 0, right = 1 },
  },

  fileformat = {
    "fileformat",
    fmt = string.upper,
    icons_enabled = true,
    cond = conditions.not_empty_buffer,
    padding = { left = 0, right = 1 },
  },

  progress = {
    "progress",
    cond = conditions.is_in_width_limit,
    color = { fg = colors.bg, bg = colors.lavender },
  },

  scrollbar = {
    functions.scrollbar,
    color = { fg = colors.red, bg = colors.lavender },
    padding = 0,
  },
}

return components
