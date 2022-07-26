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
      "stevearc/dressing.nvim",
      config = function()
        require("latipun.plugins.dressing").config()
      end,
      event = "BufWinEnter",
    },
    {
      "nathom/filetype.nvim",
      config = function()
        require("latipun.plugins.filetype").config()
      end,
    },
    {
      "sindrets/diffview.nvim",
      opt = true,
      cmd = { "DiffviewOpen", "DiffviewFileHistory" },
      module = "diffview",
      keys = "<leader>gd",
      config = function()
        require("diffview").setup({
          enhanced_diff_hl = true,
          key_bindings = {
            file_panel = { q = "<Cmd>DiffviewClose<CR>" },
            view = { q = "<Cmd>DiffviewClose<CR>" },
          },
        })
      end,
    },
    { "tpope/vim-surround", event = "BufRead" },
    { "tpope/vim-repeat", after = "vim-surround" },
    { "gpanders/editorconfig.nvim" },
    { "wakatime/vim-wakatime" },
  }
end

return M
