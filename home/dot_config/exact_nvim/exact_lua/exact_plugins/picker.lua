return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      win = {
        input = {
          keys = {
            ["<c-h>"] = { "toggle_hidden", mode = { "i", "n" } },
            ["<c-i>"] = { "toggle_ignored", mode = { "i", "n" } },
            ["H"] = { "toggle_hidden", mode = { "n" } },
            ["I"] = { "toggle_ignored", mode = { "n" } },
            ["F"] = { "toggle_follow", mode = { "n" } },
          },
        },
      },
    },
  },
}
