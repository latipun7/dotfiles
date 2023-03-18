local M = {}

M.keybindings = function()
  lvim.builtin.which_key.mappings["<leader>"] = {
    "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>",
    " Harpoon menu",
  }
  lvim.builtin.which_key.mappings["1"] = { "<Cmd>lua require('harpoon.ui').nav_file(1)<CR>", " Goto file mark1" }
  lvim.builtin.which_key.mappings["2"] = { "<Cmd>lua require('harpoon.ui').nav_file(2)<CR>", " Goto file mark2" }
  lvim.builtin.which_key.mappings["3"] = { "<Cmd>lua require('harpoon.ui').nav_file(3)<CR>", " Goto file mark3" }
  lvim.builtin.which_key.mappings["4"] = { "<Cmd>lua require('harpoon.ui').nav_file(4)<CR>", " Goto file mark4" }
  lvim.builtin.which_key.mappings.a = { "<Cmd>lua require('harpoon.mark').add_file()<CR>", " Add file mark" }
end

return M
