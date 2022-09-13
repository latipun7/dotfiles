local M = {}

M.keybindings = function()
  lvim.builtin.which_key.mappings.c = { "<Cmd>Bdelete<CR>", " Close buffer" }
  lvim.builtin.which_key.mappings.b.w =
    { "<Cmd>bufdo Bdelete<CR>", " Close all buffers" }
  lvim.builtin.which_key.mappings.b.c =
    { [[<Cmd>%bdelete|e#|bdelete#<CR>]], " Close all but this" }
end

return M
