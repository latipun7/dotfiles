local M = {}

M.keybindings = function()
  lvim.builtin.which_key.mappings["g"]["d"] = {
    "<Cmd>DiffviewOpen<CR>",
    "Diffview: diff HEAD",
  }
  lvim.builtin.which_key.mappings["g"]["h"] = {
    "<Cmd>DiffviewFileHistory<CR>",
    "Diffview: diff history",
  }
end

M.config = function()
  require("diffview").setup({
    enhanced_diff_hl = true,
    key_bindings = {
      file_panel = { q = "<Cmd>DiffviewClose<CR>" },
      view = { q = "<Cmd>DiffviewClose<CR>" },
    },
  })
end

return M
