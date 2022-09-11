local M = {}
local expr_opts = { noremap = true, expr = true, silent = true }

M.set_terminal_keymaps = function()
  local opts = { noremap = true, silent = true }

  vim.api.nvim_buf_set_keymap(0, "t", "<Esc>", [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", "<Nop>", opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", "<Nop>", opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", "<Nop>", opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", "<Nop>", opts)
end

M.config = function()
  -- keymappings [view all the defaults by pressing <Leader>Lk]
  lvim.leader = "space"

  -- add keymapping
  lvim.keys.normal_mode["<C-s>"] = ":w<CR>"

  -- Move virtual lines (lines that wrap)
  lvim.keys.normal_mode["j"] = { [[v:count == 0 ? "gj" : "j"]], expr_opts }
  lvim.keys.normal_mode["k"] = { [[v:count == 0 ? "gk" : "k"]], expr_opts }

  -- Movement in insert mode
  lvim.keys.insert_mode["<C-h>"] = "<C-o>h"
  lvim.keys.insert_mode["<C-j>"] = "<C-o>j"
  lvim.keys.insert_mode["<C-k>"] = "<C-o>k"
  lvim.keys.insert_mode["<C-l>"] = "<C-o>l"

  -- Paste still contains yanked words
  lvim.keys.visual_mode["p"] = [["_dP]]
  lvim.keys.visual_mode["P"] = [["_dP]]

  -- WhichKey
  lvim.builtin.which_key.mappings["t"] =
    { "<Cmd>set list!<CR>", "Toggle hidden characters" }
  lvim.builtin.which_key.mappings["g"]["g"] = {
    "<Cmd>lua require('lvim.core.terminal')._exec_toggle({cmd = 'lazygit', count = 1, direction = 'float'})<CR>",
    "LazyGit Dashboard",
  }
end

return M
