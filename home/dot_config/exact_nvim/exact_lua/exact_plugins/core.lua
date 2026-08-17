return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-nvim",
      news = {
        lazyvim = true,
        neovim = false,
      },
    },
  },
  {
    "folke/flash.nvim",
    commit = "c92888d432bebeb145dad09c07ab65cc7c577184",
    keys = function()
      return {
        { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
        { "S", mode = { "n", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
        { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
      }
    end,
  },
}
