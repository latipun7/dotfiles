local M = {}

M.config = function()
  local present, alpha = pcall(require, "alpha")
  if not present then
    return
  end

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

  local header = {
    type = "text",
    val = require("latipun.banners").dashboard(),
    opts = {
      position = "center",
      hl = "Error",
    },
  }

  local date = ""
  local plugins = #vim.fn.globpath(
    get_runtime_dir() .. "/site/pack/packer/*",
    "*",
    0,
    1
  )

  if vim.fn.has("unix") == 1 or vim.fn.has("mac") == 1 then
    local thingy = io.popen(
      'echo "$(date +%a) $(date +%d) $(date +%b)" | tr -d "\n"'
    )
    date = thingy:read("*a")
    thingy:close()
  else
    date = "  whatever "
  end

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

  local heading = {
    type = "text",
    val = "┌─ " .. kind.icons.calendar .. " Today is " .. date .. " ─┐",
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

  local function button(sc, txt, keybind)
    local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")

    local opts = {
      position = "center",
      text = txt,
      shortcut = sc,
      cursor = 5,
      width = 24,
      align_shortcut = "right",
      hl_shortcut = "Number",
      hl = "Function",
    }

    if keybind then
      opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true } }
    end

    return {
      type = "button",
      val = txt,
      on_press = function()
        local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
        vim.api.nvim_feedkeys(key, "normal", false)
      end,
      opts = opts,
    }
  end

  local buttons = {
    type = "group",
    val = {
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
    },
    opts = {
      spacing = 1,
    },
  }

  local section = {
    header = header,
    buttons = buttons,
    plugin_count = plugin_count,
    heading = heading,
    footer = footer,
  }

  local opts = {
    layout = {
      { type = "padding", val = 1 },
      section.header,
      { type = "padding", val = 2 },
      section.heading,
      section.plugin_count,
      { type = "padding", val = 1 },
      section.buttons,
      section.footer,
    },
    opts = {
      margin = 5,
    },
  }

  alpha.setup(opts)
end

return M
