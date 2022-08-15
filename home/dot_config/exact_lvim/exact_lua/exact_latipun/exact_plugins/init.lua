local M = {}

M.config = function()
  -- Additional Plugins
  lvim.plugins = {
    {
      "catppuccin/nvim",
      as = "catppuccin",
      config = function()
        require("latipun.plugins.catppuccin").config()
        vim.g.catppuccin_flavour = "mocha"
        vim.cmd([[colorscheme catppuccin]])
      end,
    },
    {
      "phaazon/hop.nvim",
      event = "BufRead",
      config = function()
        require("latipun.plugins.hop").config()
      end,
    },
    {
      "norcalli/nvim-colorizer.lua",
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
      "folke/persistence.nvim",
      event = "BufReadPre",
      module = "persistence",
      config = function()
        require("persistence").setup()
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
      event = "BufRead",
      tag = "*",
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
    { "alker0/chezmoi.vim" },
    { "gpanders/editorconfig.nvim" },
    { "wakatime/vim-wakatime" },
  }
end

return M
