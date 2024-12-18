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
            "<leader>ux",
            "<Cmd>CellularAutomaton make_it_rain<CR>",
            desc = "See it yourself!",
            icon = { icon = "󰇹 ", color = "yellow" },
          },
        },
      })
    end,
  },
}
