local M = {}

M.keybindings = function()
  lvim.builtin.which_key.mappings["g"]["d"] = {
    "<Cmd>DiffviewOpen<CR>",
    " Open diffview",
  }
  lvim.builtin.which_key.mappings["g"]["h"] = {
    "<Cmd>DiffviewFileHistory<CR>",
    " Diff history",
  }
  lvim.builtin.which_key.mappings["g"]["f"] = {
    "<Cmd>DiffviewFileHistory %<CR>",
    " Current file diff history",
  }
end

M.config = function()
  require("diffview").setup({
    enhanced_diff_hl = true,
    key_bindings = {
      view = { q = "<Cmd>DiffviewClose<CR>" },
      file_panel = { q = "<Cmd>DiffviewClose<CR>" },
      file_history_panel = { q = "<Cmd>DiffviewClose<CR>" },
    },
  })
end

return M
