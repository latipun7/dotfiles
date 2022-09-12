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

-- Color table for highlights
local mode_color = {
  n = colors.git.delete,
  i = colors.green,
  v = colors.yellow,
  [""] = colors.blue,
  V = colors.yellow,
  c = colors.cyan,
  no = colors.magenta,
  s = colors.orange,
  S = colors.orange,
  ic = colors.yellow,
  R = colors.violet,
  Rv = colors.violet,
  cv = colors.red,
  ce = colors.red,
  r = colors.cyan,
  rm = colors.cyan,
  ["r?"] = colors.cyan,
  ["!"] = colors.red,
  t = colors.red,
}

local components = {
  mode = {
    functions.mode,
    color = function()
      return { fg = mode_color[vim.fn.mode()], bg = colors.bg }
    end,
    padding = { left = 1, right = 0 },
  },

  git_branch = {
    "b:gitsigns_head",
    icon = " ",
    cond = conditions.is_git_workspace,
    color = { fg = colors.blue, bg = colors.bg },
    padding = { right = 1 },
  },

  win_icon = {
    functions.win_icon,
    cond = conditions.not_empty_buffer,
    color = function()
      return { fg = get_file_icon_color() }
    end,
    gui = "bold",
    padding = 0,
  },

  filetype = {
    "filetype",
    colored = true,
    icon_only = true,
  },

  filename = {
    functions.filename,
    cond = conditions.not_empty_buffer,
    padding = { left = 0, right = 1 },
    color = { fg = colors.fg, gui = "bold" },
  },

  diff = {
    "diff",
    source = diff_source,
    symbols = { added = " ", modified = "柳", removed = " " },
    diff_color = {
      added = { fg = colors.git.add, bg = colors.bg },
      modified = { fg = colors.git.change, bg = colors.bg },
      removed = { fg = colors.git.delete, bg = colors.bg },
    },
  },

  python_env = {
    functions.python_env,
    color = { fg = colors.green },
    cond = conditions.is_in_width_limit,
  },

  testing = {
    functions.testing,
    cond = function()
      return functions.testing() ~= nil
    end,
  },

  session = {
    functions.session,
    cond = function()
      return (vim.g.persisting ~= nil)
    end,
  },

  readonly = { functions.readonly, color = { fg = colors.red } },

  diagnostic = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = {
      error = kind.icons.error,
      warn = kind.icons.warn,
      info = kind.icons.info,
      hint = kind.icons.hint,
    },
    cond = conditions.is_in_width_limit,
  },

  treesitter = {
    functions.treesitter,
    padding = 0,
    color = { fg = colors.green },
    cond = conditions.is_in_width_limit,
  },

  lsp_status = {
    functions.lsp_status,
    color = { fg = colors.fg },
    cond = conditions.is_in_width_limit,
  },

  location = {
    "location",
    padding = { left = 1 },
    color = { fg = colors.orange },
  },

  filesize = { functions.filesize, cond = conditions.not_empty_buffer },

  fileformat = {
    "fileformat",
    fmt = string.upper,
    icons_enabled = true,
    color = { fg = colors.green, gui = "bold" },
    cond = conditions.is_in_width_limit,
  },

  scrollbar = {
    functions.scrollbar,
    padding = 0,
    color = { fg = colors.yellow, bg = colors.bg },
  },
}

return components
