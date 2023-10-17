return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      popup_border_style = "rounded",
      source_selector = {
        winbar = true,
        statusline = false,
        tabs_layout = "active",
      },
      default_component_configs = {
        indent = {
          padding = 0,
          with_expanders = false,
        },
        modified = { symbol = "" },
      },
      window = {
        position = "left",
        width = 30,
        mappings = {
          h = "close_node",
          l = "open",
          S = "noop",
          s = "open_split",
          v = "open_vsplit",
          ["<Space>"] = "noop",
        },
      },
      filesystem = {
        group_empty_dirs = true,
        filtered_items = {
          visible = false,
          hide_dotfiles = true,
          hide_gitignored = true,
          hide_by_name = {
            ".DS_Store",
            "thumbs.db",
            "node_modules",
            "__pycache__",
          },
          never_show = { ".DS_Store" },
        },
        follow_current_file = { enabled = true },
        hijack_netrw_behavior = "open_current",
        use_libuv_file_watcher = true,
      },
      git_status = {
        window = { position = "float" },
      },
      event_handlers = {
        {
          event = "vim_buffer_enter",
          handler = function(_)
            if vim.bo.filetype == "neo-tree" then vim.wo.signcolumn = "auto" end
          end,
        },
      },
    },
  },
}
