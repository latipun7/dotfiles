local M = {}
local expr_opts = { noremap = true, expr = true }

M.set_terminal_keymaps = function()
  local opts = { noremap = true }
  vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
end

M.set_hop_keymaps = function()
  local opts = { noremap = true, silent = true }
  vim.api.nvim_set_keymap("n", "S", ":HopChar2<cr>", opts)
  vim.api.nvim_set_keymap("n", "s", ":HopWord<cr>", opts)
  vim.api.nvim_set_keymap(
    "",
    "f",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>",
    {}
  )
  vim.api.nvim_set_keymap(
    "",
    "F",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>",
    {}
  )
  vim.api.nvim_set_keymap(
    "o",
    "f",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, inclusive_jump = true })<cr>",
    {}
  )
  vim.api.nvim_set_keymap(
    "o",
    "F",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, inclusive_jump = true })<cr>",
    {}
  )
  vim.api.nvim_set_keymap(
    "",
    "t",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>",
    {}
  )
  vim.api.nvim_set_keymap(
    "",
    "T",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>",
    {}
  )
end

M.config = function()
  -- keymappings [view all the defaults by pressing <leader>Lk]
  lvim.leader = "space"

  -- add keymapping
  lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

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

  -- Move text up and down
  lvim.keys.visual_mode["<A-j>"] = ":m .+1<CR>gv"
  lvim.keys.visual_mode["<A-k>"] = ":m .-2<CR>gv"

  -- WhichKey
  lvim.builtin.which_key.mappings[";"] = { "<cmd>Alpha<CR>", "Dashboard" }
  lvim.builtin.which_key.mappings["t"] = { "<cmd>set list!<CR>", "Toggle List" }
end

return M
