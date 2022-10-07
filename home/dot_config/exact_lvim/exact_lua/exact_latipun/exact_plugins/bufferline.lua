local M = {}
local kind = require("latipun.lsp_kind")

local function diagnostics_indicator(_, _, diagnostics)
  local result_table = {}
  local symbols = {
    error = kind.icons.error .. " ",
    warning = kind.icons.warn .. " ",
    info = kind.icons.info .. " ",
  }

  for name, count in pairs(diagnostics) do
    if symbols[name] and count > 0 then
      table.insert(result_table, symbols[name] .. count)
    end
  end

  local result = table.concat(result_table, " ")
  return #result > 0 and result or ""
end

local function highlight()
  local colors = require("latipun.theme").current_colors()
  local ok, catppuccin =
    pcall(require, "catppuccin.groups.integrations.bufferline")

  if ok then
    return catppuccin.get({
      custom = {
        all = {
          group_label = { bg = colors.sapphire, fg = colors.bg },
          group_separator = { fg = colors.sapphire },
          offset_separator = {
            bg = colors.dark,
            fg = colors.fg,
            italic = true,
            bold = true,
          },
        },
      },
    })
  else
    return {
      buffer_selected = { bold = true, italic = true },
    }
  end
end

local g_ok, bufferline_groups = pcall(require, "bufferline.groups")
if not g_ok then
  bufferline_groups = {
    builtin = {
      pinned = { name = "pinned" },
      ungrouped = { name = "ungrouped" },
    },
  }
end

M.config = function()
  lvim.builtin.bufferline.highlights = highlight()

  lvim.builtin.bufferline.options = {
    navigation = { mode = "uncentered" },
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = false,
    diagnostics_indicator = diagnostics_indicator,
    mode = "buffers",
    sort_by = "insert_after_current",
    groups = {
      options = {
        toggle_hidden_on_enter = true,
      },
      items = {
        bufferline_groups.builtin.pinned:with({ icon = "" }),
        {
          name = "config",
          icon = kind.icons.config,
          matcher = function(buf)
            local filename = buf.filename
            if filename == nil then return false end
            return filename:match("go.mod")
              or filename:match("go.sum")
              or filename:match("Cargo.toml")
              or filename:match("manage.py")
              or filename:match("Makefile")
              or filename:match("config")
              or filename:match("package")
          end,
        },
        bufferline_groups.builtin.ungrouped,
        {
          name = "tests",
          icon = kind.icons.test,
          matcher = function(buf)
            local name = buf.filename
            return name:match("_spec")
              or name:match("_test")
              or name:match("test_")
          end,
        },
        {
          name = "docs",
          icon = kind.icons.docs,
          matcher = function(buf)
            for _, ext in ipairs({ "md", "txt", "org", "norg", "wiki" }) do
              if ext == vim.fn.fnamemodify(buf.path, ":e") then return true end
            end
          end,
        },
        {
          name = "deps",
          icon = kind.icons.code_action,
          matcher = function(buf)
            return vim.startswith(
              buf.path,
              string.format("%s/site/pack/packer", vim.fn.stdpath("data"))
            ) or vim.startswith(
              buf.path,
              vim.fn.expand("$VIMRUNTIME")
            ) or string.find(buf.path, "node_modules")
          end,
        },
      },
    },
    offsets = {
      {
        text = "ﰤ Explorer",
        filetype = "neo-tree",
        highlight = "BufferLineOffsetSeparator",
        padding = 1,
      },
      {
        text = "ﰤ Explorer",
        filetype = "NvimTree",
        highlight = "BufferLineOffsetSeparator",
        padding = 1,
      },
      {
        text = " Flutter Outline",
        filetype = "flutterToolsOutline",
        highlight = "BufferLineOffsetSeparator",
        padding = 1,
      },
      {
        text = " Undotree",
        filetype = "undotree",
        highlight = "BufferLineOffsetSeparator",
        padding = 1,
      },
      {
        text = " Packer",
        filetype = "packer",
        highlight = "BufferLineOffsetSeparator",
        padding = 1,
      },
      {
        text = " Database Viewer",
        filetype = "dbui",
        highlight = "BufferLineOffsetSeparator",
        padding = 1,
      },
      {
        text = " Diff View",
        filetype = "DiffviewFiles",
        highlight = "BufferLineOffsetSeparator",
        padding = 1,
      },
    },
    separator_style = "slant",
    right_mouse_command = "vert sbuffer %d",
    show_close_icon = false,
    indicator = {
      icon = "▎",
      style = "icon",
    },
    max_name_length = 18,
    max_prefix_length = 15,
    truncate_names = true,
    tab_size = 18,
    color_icons = true,
    show_buffer_close_icons = true,
  }
end

return M
