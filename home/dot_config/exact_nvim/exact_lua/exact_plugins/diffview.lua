return {
  {
    "sindrets/diffview.nvim",
    lazy = true,
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<Cmd>DiffviewOpen<CR>", desc = "Open diffview" },
      { "<leader>gf", "<Cmd>DiffviewFileHistory %<CR>", desc = "Current file diff history" },
      { "<leader>gi", "<Cmd>DiffviewFileHistory<CR>", desc = "Diff history" },
    },
    opts = {
      enhanced_diff_hl = true,
      key_bindings = {
        view = { q = "<Cmd>DiffviewClose<CR>" },
        file_panel = { q = "<Cmd>DiffviewClose<CR>" },
        file_history_panel = { q = "<Cmd>DiffviewClose<CR>" },
      },
    },
  },
}
