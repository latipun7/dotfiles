---@diagnostic disable: need-check-nil
local functions = require("plugins.lualine.functions")
local conditions = require("plugins.lualine.conditions")
local colors = require("catppuccin.palettes").get_palette()
local icons = require("lazyvim.config").icons

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
    if icon ~= nil then return vim.fn.synIDattr(vim.fn.hlID(iconhl), "fg") end
  end
end

local components = {
  mode = { functions.mode, padding = { left = 1, right = 0 } },

  git_branch = {
    "b:gitsigns_head",
    icon = "",
    padding = { left = 1, right = 1 },
    cond = conditions.is_git_workspace,
  },

  win_icon = {
    functions.win_icon,
    cond = conditions.not_empty_buffer,
    color = function() return { fg = get_file_icon_color() } end,
    padding = { left = 1, right = 0 },
  },

  filetype = {
    "filetype",
    colored = true,
    icon_only = true,
  },

  filename = {
    "filename",
    path = 1,
    symbols = { modified = " ", readonly = "", unnamed = "" },
    cond = conditions.not_empty_buffer,
    color = { fg = colors.text },
    padding = { left = 0, right = 1 },
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

  session = {
    functions.session,
    color = { fg = colors.flamingo },
    cond = function() return (vim.g.persisting ~= nil) end,
    padding = { left = 1, right = 0 },
  },

  treesitter = {
    functions.treesitter,
    color = function()
      local buf = vim.api.nvim_get_current_buf()
      local ts = vim.treesitter.highlighter.active[buf]
      return {
        fg = ts and not vim.tbl_isempty(ts) and colors.green or colors.red,
      }
    end,
    padding = { left = 1, right = 0 },
  },

  auto_format = {
    functions.auto_format,
    color = { fg = colors.sapphire },
  },

  showmode = {
    ---@diagnostic disable-next-line: undefined-field
    function() return require("noice").api.status.mode.get() end,
    ---@diagnostic disable-next-line: undefined-field
    cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
    color = { fg = colors.pink },
  },

  dap_status = {
    function() return "  " .. require("dap").status() end,
    cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
    color = { fg = colors.mauve },
    padding = { left = 0, right = 1 },
  },

  lazy_status = {
    require("lazy.status").updates,
    cond = require("lazy.status").has_updates,
    color = { fg = colors.flamingo },
    padding = { left = 0, right = 1 },
    separator = "",
  },

  diagnostic = {
    "diagnostics",
    symbols = {
      error = icons.diagnostics.Error,
      warn = icons.diagnostics.Warn,
      info = icons.diagnostics.Info,
      hint = icons.diagnostics.Hint,
    },
    cond = conditions.is_in_width_limit,
    separator = "",
  },

  lsp_status = {
    functions.lsp_status,
    color = { fg = colors.text },
    cond = conditions.is_in_width_limit,
  },

  location = {
    "location",
    color = { fg = colors.peach },
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
    color = { fg = colors.mantle, bg = colors.lavender },
  },

  scrollbar = {
    functions.scrollbar,
    color = { fg = colors.red, bg = colors.lavender },
    padding = 0,
  },
}

return components
