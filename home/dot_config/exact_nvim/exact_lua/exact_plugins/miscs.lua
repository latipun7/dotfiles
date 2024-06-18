return {
  { "wakatime/vim-wakatime" },
  { "akinsho/git-conflict.nvim", version = "*", event = "VeryLazy", config = true },
  {
    "eandrju/cellular-automaton.nvim",
    cmd = "CellularAutomaton",
    keys = { { "<leader>X", "<Cmd>CellularAutomaton make_it_rain<CR>", desc = "󰇹  See it yourself!" } },
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "󰚀  Zen Mode" } },
  },
}
