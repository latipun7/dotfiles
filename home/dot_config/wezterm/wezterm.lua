local wezterm = require("wezterm")

local act = wezterm.action
local mocha = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]

wezterm.on("update-right-status", function(window)
  local config = window:effective_config()
  local session_name = "L"
  local session_color = mocha.ansi[1]
  for _, v in ipairs(config.unix_domains) do
    if v.name ~= nil and v.name ~= "" then
      session_name = v.name
      session_color = mocha.ansi[4]
      break
    end
  end

  window:set_right_status(wezterm.format({
    { Foreground = { Color = mocha.foreground } },
    { Text = wezterm.strftime("%H:%M %e %h") },
    { Attribute = { Intensity = "Bold" } },
    { Foreground = { Color = session_color } },
    { Text = " " .. session_name },
  }))
end)

return {
  -- fonts
  font = wezterm.font_with_fallback({ "monospace", "Symbols Nerd Font" }),
  font_size = 13,

  -- colors & appearance
  color_scheme = "Catppuccin Mocha",
  colors = {
    cursor_border = "#74c7ec",
    cursor_bg = "#74c7ec",
    cursor_fg = "#11111b",
  },
  background = {
    {
      source = { Color = mocha.background },
      opacity = 0.75,
      height = "100%",
      width = "100%",
    },
    {
      source = { File = "/home/data/pictures/random/dyah-latif.png" },
      vertical_align = "Top",
      horizontal_align = "Right",
      vertical_offset = "1cell",
      horizontal_offset = "-1cell",
      repeat_x = "NoRepeat",
      repeat_y = "NoRepeat",
      opacity = 0.85,
      height = 145,
      width = 145,
      hsb = { brightness = 0.2 },
    },
  },
  window_padding = { left = 7, right = 7, top = 7, bottom = 7 },
  default_cursor_style = "BlinkingUnderline",
  cursor_blink_ease_in = "Linear",
  cursor_blink_ease_out = "Linear",
  cursor_blink_rate = 354,
  hide_tab_bar_if_only_one_tab = true,
  tab_bar_at_bottom = true,

  -- bindings
  disable_default_key_bindings = true,
  leader = { mods = "CTRL", key = "a", timeout_milliseconds = 1000 },

  mouse_bindings = {
    { mods = "NONE", event = { Down = { streak = 1, button = "Right" } }, action = act.PasteFrom("Clipboard") },
    {
      mods = "NONE",
      event = { Down = { streak = 3, button = "Left" } },
      action = wezterm.action.SelectTextAtMouseCursor("SemanticZone"),
    },
  },

  keys = {
    { mods = "LEADER|CTRL", key = "a", action = act({ SendString = "\x01" }) }, -- literally send <C-a>
    { mods = "LEADER", key = "Enter", action = "ActivateCopyMode" },
    { mods = "LEADER", key = "Space", action = "QuickSelect" },
    { mods = "LEADER", key = "s", action = "ShowLauncher" },
    { mods = "CTRL|SHIFT", key = "L", action = act.ShowDebugOverlay },
    { mods = "CTRL|SHIFT", key = "P", action = act.ActivateCommandPalette },
    { mods = "CTRL|SHIFT", key = "F", action = act.Search("CurrentSelectionOrEmptyString") },

    -- panes
    { mods = "LEADER|SHIFT", key = "|", action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
    { mods = "LEADER|SHIFT", key = "_", action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
    { mods = "LEADER", key = "h", action = act({ ActivatePaneDirection = "Left" }) },
    { mods = "LEADER", key = "j", action = act({ ActivatePaneDirection = "Down" }) },
    { mods = "LEADER", key = "k", action = act({ ActivatePaneDirection = "Up" }) },
    { mods = "LEADER", key = "l", action = act({ ActivatePaneDirection = "Right" }) },
    { mods = "LEADER|SHIFT", key = "P", action = act.PaneSelect({ alphabet = "", mode = "Activate" }) },
    { mods = "LEADER|SHIFT", key = "H", action = act({ AdjustPaneSize = { "Left", 2 } }) },
    { mods = "LEADER|SHIFT", key = "J", action = act({ AdjustPaneSize = { "Down", 2 } }) },
    { mods = "LEADER|SHIFT", key = "K", action = act({ AdjustPaneSize = { "Up", 2 } }) },
    { mods = "LEADER|SHIFT", key = "L", action = act({ AdjustPaneSize = { "Right", 2 } }) },
    { mods = "LEADER", key = "z", action = "TogglePaneZoomState" },
    { mods = "LEADER", key = "x", action = act({ CloseCurrentPane = { confirm = true } }) },

    -- tabs
    { mods = "LEADER", key = "c", action = act({ SpawnTab = "CurrentPaneDomain" }) },
    { mods = "LEADER", key = "n", action = act({ ActivateTabRelative = 1 }) },
    { mods = "LEADER", key = "p", action = act({ ActivateTabRelative = -1 }) },
    { mods = "CTRL", key = "Tab", action = act.ActivateTabRelative(1) },
    { mods = "CTRL|SHIFT", key = "Tab", action = act.ActivateTabRelative(-1) },
    { mods = "LEADER|SHIFT", key = "&", action = act({ CloseCurrentTab = { confirm = true } }) },

    -- fonts
    { mods = "CTRL|SHIFT", key = ")", action = act.ResetFontSize },
    { mods = "CTRL|SHIFT", key = "+", action = act.IncreaseFontSize },
    { mods = "CTRL|SHIFT", key = "_", action = act.DecreaseFontSize },

    -- copy & paste
    { mods = "CTRL", key = "Insert", action = act.CopyTo("PrimarySelection") },
    { mods = "NONE", key = "Copy", action = act.CopyTo("Clipboard") },
    { mods = "NONE", key = "Paste", action = act.PasteFrom("Clipboard") },
    { mods = "CTRL|SHIFT", key = "C", action = act.CopyTo("Clipboard") },
    { mods = "CTRL|SHIFT", key = "V", action = act.PasteFrom("Clipboard") },
    { mods = "SHIFT", key = "Insert", action = act.PasteFrom("PrimarySelection") },
    {
      mods = "CTRL|SHIFT",
      key = ">",
      action = act.CharSelect({ copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" }),
    },

    -- motions
    { mods = "CTRL|SHIFT", key = "U", action = act.ScrollByPage(-0.5) },
    { mods = "CTRL|SHIFT", key = "D", action = act.ScrollByPage(0.5) },
    { mods = "CTRL|SHIFT", key = "B", action = act.ScrollByPage(-1) },
    { mods = "CTRL|SHIFT", key = "F", action = act.ScrollByPage(1) },
    { mods = "SHIFT", key = "PageUp", action = act.ScrollByPage(-1) },
    { mods = "SHIFT", key = "PageDown", action = act.ScrollByPage(1) },
    { mods = "CTRL|SHIFT", key = "PageUp", action = act.ScrollToPrompt(-1) },
    { mods = "CTRL|SHIFT", key = "PageDown", action = act.ScrollToPrompt(1) },
    { mods = "CTRL|SHIFT", key = "K", action = act.ScrollByLine(-1) },
    { mods = "CTRL|SHIFT", key = "J", action = act.ScrollByLine(1) },
  },

  key_tables = {
    copy_mode = {
      { mods = "NONE", key = "Escape", action = act.CopyMode("Close") },
      { mods = "CTRL", key = "c", action = act.CopyMode("Close") },
      { mods = "NONE", key = "q", action = act.CopyMode("Close") },

      -- selection
      { mods = "NONE", key = "v", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
      { mods = "NONE", key = "Space", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
      { mods = "SHIFT", key = "V", action = act.CopyMode({ SetSelectionMode = "Line" }) },
      { mods = "CTRL", key = "v", action = act.CopyMode({ SetSelectionMode = "Block" }) },

      -- copy selection
      {
        mods = "NONE",
        key = "y",
        action = act.Multiple({ { CopyTo = "ClipboardAndPrimarySelection" }, { CopyMode = "Close" } }),
      },

      -- motions
      { mods = "NONE", key = "PageUp", action = act.CopyMode("PageUp") },
      { mods = "NONE", key = "PageDown", action = act.CopyMode("PageDown") },
      { mods = "CTRL", key = "b", action = act.CopyMode("PageUp") },
      { mods = "CTRL", key = "f", action = act.CopyMode("PageDown") },
      { mods = "CTRL", key = "u", action = act.CopyMode({ MoveByPage = -0.5 }) },
      { mods = "CTRL", key = "d", action = act.CopyMode({ MoveByPage = 0.5 }) },

      { mods = "NONE", key = "Tab", action = act.CopyMode("MoveForwardWord") },
      { mods = "SHIFT", key = "Tab", action = act.CopyMode("MoveBackwardWord") },
      { mods = "ALT", key = "RightArrow", action = act.CopyMode("MoveForwardWord") },
      { mods = "ALT", key = "LeftArrow", action = act.CopyMode("MoveBackwardWord") },

      { mods = "NONE", key = "LeftArrow", action = act.CopyMode("MoveLeft") },
      { mods = "NONE", key = "RightArrow", action = act.CopyMode("MoveRight") },
      { mods = "NONE", key = "UpArrow", action = act.CopyMode("MoveUp") },
      { mods = "NONE", key = "DownArrow", action = act.CopyMode("MoveDown") },

      { mods = "SHIFT", key = "O", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
      { mods = "NONE", key = "o", action = act.CopyMode("MoveToSelectionOtherEnd") },

      { mods = "NONE", key = "[", action = act.CopyMode("JumpReverse") },
      { mods = "NONE", key = "]", action = act.CopyMode("JumpAgain") },

      -- horizontal motions
      { mods = "NONE", key = "0", action = act.CopyMode("MoveToStartOfLine") },
      { mods = "SHIFT", key = "^", action = act.CopyMode("MoveToStartOfLineContent") },
      { mods = "SHIFT", key = "F", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
      { mods = "SHIFT", key = "T", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
      { mods = "NONE", key = "b", action = act.CopyMode("MoveBackwardWord") },
      { mods = "NONE", key = "h", action = act.CopyMode("MoveLeft") },

      { mods = "NONE", key = "l", action = act.CopyMode("MoveRight") },
      { mods = "NONE", key = "e", action = act.CopyMode("MoveForwardWordEnd") },
      { mods = "NONE", key = "w", action = act.CopyMode("MoveForwardWord") },
      { mods = "NONE", key = "t", action = act.CopyMode({ JumpForward = { prev_char = true } }) },
      { mods = "NONE", key = "f", action = act.CopyMode({ JumpForward = { prev_char = false } }) },
      { mods = "SHIFT", key = "$", action = act.CopyMode("MoveToEndOfLineContent") },

      -- vertical motions
      { mods = "NONE", key = "g", action = act.CopyMode("MoveToScrollbackTop") },
      { mods = "SHIFT", key = "G", action = act.CopyMode("MoveToScrollbackBottom") },
      { mods = "SHIFT", key = "H", action = act.CopyMode("MoveToViewportTop") },
      { mods = "SHIFT", key = "M", action = act.CopyMode("MoveToViewportMiddle") },
      { mods = "SHIFT", key = "L", action = act.CopyMode("MoveToViewportBottom") },
      { mods = "NONE", key = "k", action = act.CopyMode("MoveUp") },
      { mods = "NONE", key = "j", action = act.CopyMode("MoveDown") },
      { mods = "SHIFT", key = "V", action = act.CopyMode({ SetSelectionMode = "Line" }) },
    },

    search_mode = {
      { mods = "NONE", key = "Escape", action = act.CopyMode("Close") },
      { mods = "NONE", key = "Enter", action = act.CopyMode("PriorMatch") },
      { mods = "CTRL", key = "n", action = act.CopyMode("NextMatch") },
      { mods = "CTRL", key = "p", action = act.CopyMode("PriorMatch") },
      { mods = "CTRL", key = "r", action = act.CopyMode("CycleMatchType") },
      { mods = "CTRL", key = "u", action = act.CopyMode("ClearPattern") },
      { mods = "NONE", key = "PageUp", action = act.CopyMode("PriorMatchPage") },
      { mods = "NONE", key = "PageDown", action = act.CopyMode("NextMatchPage") },
      { mods = "NONE", key = "UpArrow", action = act.CopyMode("PriorMatch") },
      { mods = "NONE", key = "DownArrow", action = act.CopyMode("NextMatch") },
    },
  },

  -- general
  automatically_reload_config = true,
  scrollback_lines = 100000,
}
