local M = {}

M.keybindings = function()
  lvim.builtin.which_key.mappings["c"] =
    { "<Cmd>Bdelete<CR>", " close buffer" }
  lvim.builtin.which_key.mappings["b"]["w"] =
    { "<Cmd>bufdo Bdelete<CR>", " close all buffers" }
  lvim.builtin.which_key.mappings["b"]["c"] =
    { [[<Cmd>%bdelete|e#|bdelete#<CR>]], " close all but this" }
end

return M
