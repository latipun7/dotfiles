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

  local plugins =
    #vim.fn.globpath(get_runtime_dir() .. "/site/pack/packer/*", "*", 0, 1)

  local date = ""
  if vim.fn.has("unix") == 1 or vim.fn.has("mac") == 1 then
    local thingy = io.popen(
      'echo "$(date +%a) $(date +%d) $(date +%b)" | tr -d "\n"'
    ) or "whatever"
    date = thingy:read("*a")
    thingy:close()
  else
    date = "  whatever "
  end

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
    dashboard_button.opts.width = 24

    return dashboard_button
  end

  dashboard.section.buttons.val = {
    button(
      "f",
      " " .. kind.icons.find .. " Find File",
      ":Telescope find_files<CR>"
    ),
    button(
      "e",
      " " .. kind.icons.file .. " New File",
      ":ene <BAR> startinsert <CR>"
    ),
    button(
      "s",
      " " .. kind.icons.magic .. " Restore Session",
      ":lua require('persistence').load()<cr>"
    ),
    button(
      "p",
      " " .. kind.icons.worker .. " Recent Projects",
      ":Telescope projects<CR>"
    ),
    button(
      "r",
      " " .. kind.icons.clock .. " Recent Files",
      ":Telescope oldfiles<CR>"
    ),
    button(
      "c",
      " " .. kind.icons.settings .. " Edit Config File",
      ":e " .. get_config_dir() .. "/config.lua<CR>"
    ),
    button("q", " " .. kind.icons.exit .. " Quit", ":qa<CR>"),
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
