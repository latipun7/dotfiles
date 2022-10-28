local M = {}

local create_augroup = vim.api.nvim_create_augroup
local create_aucmd = vim.api.nvim_create_autocmd

M.config = function()
  -- clear unused autocommands from LunarVim
  vim.api.nvim_clear_autocmds({ pattern = "lir", group = "_filetype_settings" })

  create_aucmd("TermOpen", {
    pattern = "term://*",
    command = "lua require('latipun.keybindings').set_terminal_keymaps()",
  })

  -- need bufdelete.nvim, neo-tree & alpha-dashboard
  local alpha_on_empty = create_augroup("alpha_on_empty", { clear = true })
  create_aucmd("User", {
    pattern = "BDeletePost*",
    group = alpha_on_empty,
    callback = function(event)
      local fallback_name = vim.api.nvim_buf_get_name(event.buf)
      local fallback_ft = vim.api.nvim_buf_get_option(event.buf, "filetype")
      local fallback_on_empty = fallback_name == "" and fallback_ft == ""

      if fallback_on_empty then
        require("neo-tree").close_all()
        vim.cmd("Alpha")
        vim.cmd(event.buf .. "bwipeout")
      end
    end,
  })
end

return M
