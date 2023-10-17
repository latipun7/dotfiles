return {
  {
    "akinsho/bufferline.nvim",
    ---@param opts bufferline.UserConfig
    opts = function(_, opts)
      local bufferline_groups = require("bufferline.groups")

      local function highlight()
        local ok, catppuccin = pcall(require, "catppuccin.groups.integrations.bufferline")
        if not ok then return { buffer_selected = { bold = true, italic = true } } end

        local colors = require("catppuccin.palettes").get_palette()

        if colors ~= nil then
          return catppuccin.get({
            buffer_selected = { bold = true, italic = true },
            custom = {
              all = {
                group_label = { bg = colors.sapphire, fg = colors.mantle },
                group_separator = { fg = colors.sapphire },
                fill = { bg = colors.crust },
                separator = { fg = colors.crust },
                separator_visible = { fg = colors.crust },
                separator_selected = { fg = colors.crust },
                offset_separator = {
                  bg = colors.crust,
                  fg = colors.text,
                  italic = true,
                  bold = true,
                },
              },
            },
          })
        else
          return { buffer_selected = { bold = true, italic = true } }
        end
      end

      opts.highlights = highlight()
      opts.options.diagnostics_update_in_insert = false
      opts.options.mode = "buffers"
      opts.options.sort_by = "insert_after_current"
      opts.options.separator_style = "slant"
      opts.options.right_mouse_command = "vert sbuffer %d"
      opts.options.show_close_icon = false
      opts.options.max_name_length = 18
      opts.options.max_prefix_length = 15
      opts.options.truncate_names = true
      opts.options.tab_size = 18
      opts.options.color_icons = true
      opts.options.show_buffer_close_icons = true
      opts.options.offsets = {
        {
          text = "󰜦 Explorer",
          filetype = "neo-tree",
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
          text = "󰇚 Plugins",
          filetype = "lazy",
          highlight = "BufferLineOffsetSeparator",
          padding = 1,
        },
        {
          text = "󰆼 Database Viewer",
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
      }
      opts.options.groups = {
        options = { toggle_hidden_on_enter = true },
        ---@diagnostic disable: missing-fields
        items = {
          bufferline_groups.builtin.pinned,
          {
            name = "conf",
            icon = "⚙️",
            matcher = function(buf)
              local name = vim.api.nvim_buf_get_name(buf.id)
              local filename_arr = vim.split(name, "/", { plain = true })
              local filename = nil
              if #filename_arr > 0 then filename = filename_arr[#filename_arr] end
              if filename == nil then return false end
              return filename:match("go.mod")
                or filename:match("go.sum")
                or filename:match("Cargo.toml")
                or filename:match("manage.py")
                or filename:match("init")
                or filename:match("Makefile")
                or filename:match("config")
                or filename:match("package")
            end,
          },
          bufferline_groups.builtin.ungrouped,
          {
            name = "test",
            icon = "🧪",
            matcher = function(buf)
              local name = vim.api.nvim_buf_get_name(buf.id)
              return name:match("_spec") or name:match("_test") or name:match("test_")
            end,
          },
          {
            name = "docs",
            icon = "📔",
            matcher = function(buf)
              for _, ext in ipairs({ "md", "txt", "org", "norg", "wiki" }) do
                if ext == vim.fn.fnamemodify(buf.path, ":e") then return true end
              end
            end,
          },
          {
            name = "deps",
            icon = "💝",
            matcher = function(buf)
              if string.find(buf.path, "node_modules") then return true end
              return vim.startswith(buf.path, string.format("%s/lazy", vim.fn.stdpath("data")))
            end,
          },
        },
        ---@diagnostic enable: missing-fields
      }
    end,
  },
}
