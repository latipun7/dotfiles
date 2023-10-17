return {
  { "wakatime/vim-wakatime" },
  { "smjonas/inc-rename.nvim", cmd = "IncRename", config = true },
  { "akinsho/git-conflict.nvim", version = "*", event = "VeryLazy", config = true },
  {
    "eandrju/cellular-automaton.nvim",
    cmd = "CellularAutomaton",
    keys = { { "<leader>X", "<Cmd>CellularAutomaton make_it_rain<CR>", desc = "󰇹  See it yourself!" } },
  },
  {
    "toppair/peek.nvim",
    ft = "markdown",
    enabled = (vim.fn.executable("deno") == 1),
    build = "deno task --quiet build:fast",
    keys = { { "<leader>P", "<Cmd>lua require('peek').open()<CR>", ft = "markdown", desc = " Previewer open" } },
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "󰚀  Zen Mode" } },
  },
}
