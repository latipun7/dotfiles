return {
  {
    "goolord/alpha-nvim",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")

      local date = os.date("%a, %d %b %y")
      local minor_len = string.len(vim.version().patch)
      local empty_space = ""
      for _ = 1, minor_len do
        empty_space = empty_space .. " "
      end

      local heading = {
        type = "text",
        val = "┌─   Today is " .. date .. empty_space .. "─┐",
        opts = {
          position = "center",
          hl = "AlphaHeaderLabel",
        },
      }

      local plugin_count = {
        type = "text",
        val = function()
          if vim.version().prerelease == "dev" then
            return "└─   Ver: "
              .. vim.version().major
              .. "."
              .. vim.version().minor
              .. "."
              .. vim.version().patch
              .. "-"
              .. vim.version().prerelease
              .. "+"
              .. vim.version().build:sub(1, 7)
              .. " ─┘"
          else
            return "└─   Ver: "
              .. vim.version().major
              .. "."
              .. vim.version().minor
              .. "."
              .. vim.version().patch
              .. " - (latest)  ─┘"
          end
        end,
        opts = {
          position = "center",
          hl = "AlphaHeaderLabel",
        },
      }

      local footer = {
        type = "text",
        val = require("alpha.fortune")(),
        opts = {
          position = "center",
          hl = "Comment",
          hl_shortcut = "Comment",
        },
      }

      dashboard.section.header.val = require("plugins.alpha-dashboard.banners").dashboard()
      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file", "<Cmd>Telescope find_files<CR>"),
        dashboard.button("n", " " .. " New file", "<Cmd>ene <Bar> startinsert<CR>"),
        dashboard.button("r", " " .. " Recent files", "<Cmd>Telescope oldfiles<CR>"),
        dashboard.button("g", " " .. " Find text", "<Cmd>Telescope live_grep<CR>"),
        dashboard.button("c", " " .. " Config", "<Cmd>e $MYVIMRC<CR>"),
        dashboard.button("s", " " .. " Restore Session", "<Cmd>lua require('persisted').load()<CR>"),
        dashboard.button("p", " " .. " Projects", ":Telescope projects <CR>"),
        dashboard.button("l", "󰒲 " .. " Lazy", "<Cmd>Lazy<CR>"),
        dashboard.button("q", " " .. " Quit", "<Cmd>qa<CR>"),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
        button.opts.width = 33
      end
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"

      dashboard.opts.layout = {
        { type = "padding", val = 1 },
        dashboard.section.header,
        { type = "padding", val = 2 },
        heading,
        plugin_count,
        { type = "padding", val = 1 },
        dashboard.section.buttons,
        dashboard.section.footer,
        footer,
      }

      return dashboard
    end,
  },
}
