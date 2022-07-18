local M = {}

local create_aucmd = vim.api.nvim_create_autocmd

M.config = function()
  create_aucmd("TermOpen", {
    pattern = "term://*",
    command = "lua require('latipun.keybindings').set_terminal_keymaps()",
  })
end

return M
