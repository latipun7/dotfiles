local M = {}

M.config = function()
  -- Additional Plugins
  lvim.plugins = {
    {
      "catppuccin/nvim",
      as = "catppuccin",
      config = function()
        require("latipun.plugins.catppuccin").config()
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
      config = function()
        require("latipun.plugins.colorizer").config()
      end,
      event = "BufRead",
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
      "goolord/alpha-nvim",
      config = function()
        require("latipun.plugins.alpha-dashboard").config()
      end,
    },
    { "editorconfig/editorconfig-vim", event = "BufRead" },
    { "tpope/vim-surround", event = "BufRead" },
    { "tpope/vim-repeat", after = "vim-surround" },
    { "wakatime/vim-wakatime" },
  }
end

return M
