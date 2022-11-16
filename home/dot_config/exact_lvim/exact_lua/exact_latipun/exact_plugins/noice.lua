local M = {}

M.config = function()
  local status_ok, noice = pcall(require, "noice")
  if not status_ok then return end

  noice.setup({
    views = { split = { enter = true } },
    cmdline = {
      format = {
        filter = { pattern = "^:%s*!", icon = "", lang = "bash" },
        rename = {
          pattern = "^:%s*IncRename%s+",
          icon = "",
          opts = {
            relative = "cursor",
            size = { min_width = 20 },
            position = { row = -3, col = 0 },
          },
        },
      },
    },
    routes = {
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
      {
        view = "split",
        filter = { event = "msg_show", min_height = 10 },
      },
      {
        view = "notify",
        filter = {
          event = "msg_show",
          kind = { "", "echo", "echomsg" },
        },
        opts = { replace = true, merge = true, title = "" },
      },
      {
        view = "notify",
        filter = { event = "msg_showmode" },
        opts = { title = "" },
      },
    },
  })
end

return M
