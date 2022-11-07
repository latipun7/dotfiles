local M = {}

M.config = function()
  -- Additional Plugins
  lvim.plugins = {
    {
      "catppuccin/nvim",
      as = "catppuccin",
      run = ":CatppuccinCompile",
      config = function() require("latipun.plugins.catppuccin").config() end,
    },
    {
      "rcarriga/nvim-notify",
      tag = "*",
      requires = { "nvim-telescope/telescope.nvim" },
      config = function() require("latipun.plugins.notify").config() end,
    },
    {
      "phaazon/hop.nvim",
      tag = "*",
      event = "BufRead",
      config = function() require("latipun.plugins.hop").config() end,
    },
    {
      "NvChad/nvim-colorizer.lua",
      event = "BufReadPre",
      config = function() require("latipun.plugins.colorizer").config() end,
    },
    {
      "andweeb/presence.nvim",
      config = function() require("latipun.plugins.presence").config() end,
    },
    {
      "olimorris/persisted.nvim",
      setup = function() require("latipun.plugins.persisted").keybindings() end,
      config = function() require("latipun.plugins.persisted").config() end,
    },
    {
      "stevearc/dressing.nvim",
      event = "BufWinEnter",
      config = function() require("latipun.plugins.dressing").config() end,
    },
    {
      "sindrets/diffview.nvim",
      setup = function() require("latipun.plugins.diffview").keybindings() end,
      config = function() require("latipun.plugins.diffview").config() end,
    },
    {
      "kevinhwang91/nvim-bqf",
      tag = "*",
      event = "BufRead",
      config = function() require("latipun.plugins.bqf").config() end,
    },
    {
      "akinsho/git-conflict.nvim",
      tag = "*",
      config = function() require("git-conflict").setup() end,
    },
    {
      "kylechui/nvim-surround",
      tag = "*",
      config = function() require("nvim-surround").setup() end,
    },
    {
      "AckslD/nvim-neoclip.lua",
      setup = function() require("latipun.plugins.neoclip").keybindings() end,
      config = function() require("latipun.plugins.neoclip").config() end,
    },
    {
      "andymass/vim-matchup",
      config = function() require("latipun.plugins.matchup").config() end,
    },
    {
      "max397574/better-escape.nvim",
      event = "InsertEnter",
      config = function() require("better_escape").setup() end,
    },
    {
      "ThePrimeagen/harpoon",
      requires = { { "nvim-lua/plenary.nvim" }, { "nvim-lua/popup.nvim" } },
      setup = function() require("latipun.plugins.harpoon").keybindings() end,
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v2.x",
      requires = { "MunifTanjim/nui.nvim" },
      config = function() require("latipun.plugins.neotree").config() end,
    },
    {
      "folke/noice.nvim",
      event = "VimEnter",
      requires = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
      config = function() require("latipun.plugins.noice").config() end,
    },
    {
      "smjonas/inc-rename.nvim",
      config = function() require("inc_rename").setup() end,
    },
    { "famiu/bufdelete.nvim", event = "BufReadPre" },
    { "hrsh7th/cmp-cmdline", event = "CmdlineEnter" },
    { "alker0/chezmoi.vim" },
    { "gpanders/editorconfig.nvim" },
    { "wakatime/vim-wakatime" },
  }
end

return M
