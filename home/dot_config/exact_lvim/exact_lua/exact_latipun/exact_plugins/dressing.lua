local M = {}

M.config = function()
  local status_ok, dressing = pcall(require, "dressing")
  if not status_ok then return end

  dressing.setup({
    input = {
      override = function(conf)
        -- position the input box above the cursor to not cover the word being renamed
        conf.col = -1
        conf.row = 0
        return conf
      end,
    },
    select = {
      format_item_override = {
        codeaction = function(action_tuple)
          local title = action_tuple[2].title:gsub("\r\n", "\\r\\n")
          local client = vim.lsp.get_client_by_id(action_tuple[1])
          return string.format("%s\t[%s]", title:gsub("\n", "\\n"), client.name)
        end,
      },
    },
  })
end

return M
