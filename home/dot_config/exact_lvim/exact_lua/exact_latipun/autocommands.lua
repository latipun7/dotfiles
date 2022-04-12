local M = {}

M.config = function()
  lvim.autocommands.custom_groups = {
    -- toggleterm
    {
      "TermOpen",
      "term://*",
      "lua require('latipun.keybindings').set_terminal_keymaps()",
    },
  }
end

return M
