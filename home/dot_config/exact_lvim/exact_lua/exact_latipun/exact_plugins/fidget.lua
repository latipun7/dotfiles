local M = {}

M.config = function()
  local status_ok, fidget = pcall(require, "fidget")
  if not status_ok then return end

  local relative = "editor"
  if lvim.builtin.global_statusline then relative = "win" end

  fidget.setup({
    text = {
      spinner = {
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
      },
      done = "",
      commenced = " ",
      completed = " ",
    },
    timer = {
      spinner_rate = 100,
      fidget_decay = 500,
      task_decay = 300,
    },
    window = { relative = relative, blend = 0 },
    fmt = { stack_upwards = false },
    sources = {
      ["null-ls"] = { ignore = true },
    },
  })
end

return M
