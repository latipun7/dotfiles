local M = {}

M.config = function()
  local kind = {
    icons = {
      plug = " ",
      calendar = " ",
      find = " ",
      file = " ",
      magic = " ",
      worker = "華",
      git = " ",
      clock = " ",
      settings = " ",
      exit = " ",
    },
  }

  local dashboard = require("alpha.themes.dashboard")

  -- require("alpha.term")
  -- dashboard.section.terminal.command = "chara"
  -- dashboard.section.terminal.height = 19

  dashboard.section.header.val = require("latipun.banners").dashboard()
  dashboard.section.header.opts.hl = "Error"

  local date = os.date("%a %d %b")
  local plugins =
    #vim.fn.globpath(get_runtime_dir() .. "/site/pack/lazy/*", "*", 0, 1)

  local heading = {
    type = "text",
    val = "┌─ " .. kind.icons.calendar .. " Today is " .. date .. " ─┐",
    opts = {
      position = "center",
      hl = "String",
    },
  }

  local plugin_count = {
    type = "text",
    val = "└─ "
      .. kind.icons.plug
      .. " "
      .. plugins
      .. " plugins in total ─┘",
    opts = {
      position = "center",
      hl = "String",
    },
  }

  local fortune = require("alpha.fortune")()
  local footer = {
    type = "text",
    val = fortune,
    opts = {
      position = "center",
      hl = "Comment",
      hl_shortcut = "Comment",
    },
  }

  local function button(shortcut, text, keybind, keybind_opts)
    local dashboard_button =
      dashboard.button(shortcut, text, keybind, keybind_opts)

    dashboard_button.opts.hl_shortcut = "Number"
    dashboard_button.opts.hl = "Function"
    dashboard_button.opts.width = 33

    return dashboard_button
  end

  dashboard.section.buttons.val = {
    button(
      "f",
      " " .. kind.icons.find .. " Find File",
      "<Cmd>lua require('latipun.plugins.telescope').find_project_files()<CR>"
    ),
    button(
      "e",
      " " .. kind.icons.file .. " New File",
      "<Cmd>ene <Bar> startinsert <CR>"
    ),
    button(
      "l",
      " " .. kind.icons.magic .. " Restore Last Session",
      "<Cmd>lua require('persisted').load({ last = true })<CR>"
    ),
    button(
      "s",
      " " .. kind.icons.magic .. " Restore Directory Session",
      "<Cmd>lua require('persisted').load()<CR>"
    ),
    button(
      "p",
      " " .. kind.icons.worker .. " Recent Projects",
      "<Cmd>Telescope projects<CR>"
    ),
    button(
      "r",
      " " .. kind.icons.clock .. " Recent Files",
      "<Cmd>Telescope oldfiles<CR>"
    ),
    button(
      "c",
      " " .. kind.icons.settings .. " Edit Config File",
      "<Cmd>e " .. get_config_dir() .. "/config.lua<CR>"
    ),
    button("q", " " .. kind.icons.exit .. " Quit", "<Cmd>qa<CR>"),
  }

  local section = {
    plugin_count = plugin_count,
    heading = heading,
    footer = footer,
  }

  dashboard.config.layout = {
    { type = "padding", val = 1 },
    dashboard.section.header,
    { type = "padding", val = 2 },
    section.heading,
    section.plugin_count,
    { type = "padding", val = 1 },
    dashboard.section.buttons,
    section.footer,
  }

  return dashboard.config
end

return M
