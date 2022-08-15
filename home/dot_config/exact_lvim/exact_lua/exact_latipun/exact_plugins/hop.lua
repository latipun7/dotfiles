local M = {}

M.keybindings = function()
  local opts = { noremap = true, silent = true }

  vim.api.nvim_set_keymap("n", "S", "<Cmd>HopChar1MW<CR>", opts)
  vim.api.nvim_set_keymap("n", "s", "<Cmd>HopWordMW<CR>", opts)
  vim.api.nvim_set_keymap(
    "",
    "f",
    "<Cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<CR>",
    {}
  )
  vim.api.nvim_set_keymap(
    "",
    "F",
    "<Cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<CR>",
    {}
  )
  vim.api.nvim_set_keymap(
    "",
    "t",
    "<Cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<CR>",
    {}
  )
  vim.api.nvim_set_keymap(
    "",
    "T",
    "<Cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<CR>",
    {}
  )
end

M.config = function()
  local status_ok, hop = pcall(require, "hop")
  if not status_ok then
    return
  end

  hop.setup()
  M.keybindings()
end

return M
