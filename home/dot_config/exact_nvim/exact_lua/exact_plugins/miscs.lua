return {
  { "wakatime/vim-wakatime" },
  { "akinsho/git-conflict.nvim", version = "*", event = "VeryLazy", config = true },
  {
    "eandrju/cellular-automaton.nvim",
    cmd = "CellularAutomaton",
    init = function()
      local wk = require("which-key")
      wk.add({
        {
          mode = { "n" },
          {
            "<leader>X",
            "<Cmd>CellularAutomaton make_it_rain<CR>",
            desc = "See it yourself!",
            icon = { icon = "󰇹 ", color = "yellow" },
          },
        },
      })
    end,
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
  },
}
