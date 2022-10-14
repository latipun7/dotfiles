local M = {}

M.config = function()
  local status_ok, noice = pcall(require, "noice")
  if not status_ok then return end

  noice.setup({
    cmdline = {
      view = "cmdline_popup",
    },
    popupmenu = {
      enabled = false,
    },
    notify = {
      enabled = lvim.builtin.notify.active,
    },
    routes = {
      {
        view = "notify",
        filter = { event = "msg_showmode" },
      },
      {
        filter = { event = "msg_show", kind = "search_count" },
        opts = { skip = true },
      },
      {
        view = "split",
        filter = { event = "msg_show", min_height = 20 },
      },
      {
        filter = {
          event = "msg_show",
          find = "; before #",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          find = "; after #",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          find = " lines, ",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          find = "go up one level",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          find = "yanked",
        },
        opts = { skip = true },
      },
      {
        filter = { find = "No active Snippet" },
        opts = { skip = true },
      },
    },
  })
end

return M
