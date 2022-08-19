local M = {}

M.config = function()
  -- Additional Plugins
  lvim.plugins = {
    {
      "catppuccin/nvim",
      as = "catppuccin",
      config = function()
        require("latipun.plugins.catppuccin").config()
      end,
    },
    {
      "phaazon/hop.nvim",
      tag = "*",
      event = "BufRead",
      config = function()
        require("latipun.plugins.hop").config()
      end,
    },
    {
      "NvChad/nvim-colorizer.lua",
      event = "BufRead",
      config = function()
        require("latipun.plugins.colorizer").config()
      end,
    },
    {
      "andweeb/presence.nvim",
      config = function()
        require("latipun.plugins.presence").config()
      end,
    },
    {
      "olimorris/persisted.nvim",
      setup = function()
        require("latipun.plugins.persisted").keybindings()
      end,
      config = function()
        require("latipun.plugins.persisted").config()
      end,
    },
    {
      "stevearc/dressing.nvim",
      event = "BufWinEnter",
      config = function()
        require("latipun.plugins.dressing").config()
      end,
    },
    {
      "nathom/filetype.nvim",
      config = function()
        require("latipun.plugins.filetype").config()
      end,
    },
    {
      "sindrets/diffview.nvim",
      cmd = { "DiffviewOpen", "DiffviewFileHistory" },
      keys = { "<Leader>gd", "<Leader>gh" },
      module = "diffview",
      setup = function()
        require("latipun.plugins.diffview").keybindings()
      end,
      config = function()
        require("latipun.plugins.diffview").config()
      end,
    },
    {
      "kevinhwang91/nvim-bqf",
      tag = "*",
      event = "BufRead",
      config = function()
        require("latipun.plugins.bqf").config()
      end,
    },
    {
      "akinsho/git-conflict.nvim",
      tag = "*",
      config = function()
        require("git-conflict").setup()
      end,
    },
    {
      "kylechui/nvim-surround",
      tag = "*",
      config = function()
        require("nvim-surround").setup()
      end,
    },
    {
      "AckslD/nvim-neoclip.lua",
      setup = function()
        require("latipun.plugins.neoclip").keybindings()
      end,
      config = function()
        require("latipun.plugins.neoclip").config()
      end,
    },
    {
      "andymass/vim-matchup",
      event = "BufReadPost",
      config = function()
        require("latipun.plugins.matchup").config()
      end,
    },
    {
      "famiu/bufdelete.nvim",
      setup = function()
        require("latipun.plugins.bufdelete").keybindings()
      end,
    },
    { "alker0/chezmoi.vim" },
    { "gpanders/editorconfig.nvim" },
    { "wakatime/vim-wakatime" },
  }
end

return M
