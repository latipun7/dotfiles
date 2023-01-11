local M = {}

M.config = function()
  local status_ok, notify = pcall(require, "notify")
  if not status_ok then return end

  if #vim.api.nvim_list_uis() == 0 then
    -- no need to configure notifications in headless
    return
  end

  notify.setup({
    stages = "slide",
    max_height = function() return math.floor(vim.o.lines * 0.8) end,
    max_width = function() return math.floor(vim.o.columns * 0.4) end,
    render = function(...)
      local notif = select(2, ...)
      local style = notif.title[1] == "" and "minimal" or "default"
      require("notify.render")[style](...)
    end,
  })

  require("telescope").load_extension("notify")
  vim.notify = require("notify")
end

return M
