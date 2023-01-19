local M = {}

M.config = function()
  -- Additional Plugins
  lvim.plugins = {
    {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 9999,
      config = function() require("latipun.plugins.catppuccin").config() end,
    },
    {
      "rcarriga/nvim-notify",
      version = "*",
      dependencies = { "nvim-telescope/telescope.nvim" },
      config = function() require("latipun.plugins.notify").config() end,
    },
    {
      "phaazon/hop.nvim",
      version = "*",
      event = "BufRead",
      config = function() require("latipun.plugins.hop").config() end,
    },
    {
      "eandrju/cellular-automaton.nvim",
      cmd = "CellularAutomaton",
      init = function()
        lvim.builtin.which_key.mappings.X = {
          "<Cmd>CellularAutomaton make_it_rain<CR>",
          " See it yourself!",
        }
      end,
    },
    {
      "utilyre/barbecue.nvim",
      enabled = lvim.builtin.latipun.barbecue.active,
      dependencies = {
        "neovim/nvim-lspconfig",
        "SmiteshP/nvim-navic",
        "nvim-tree/nvim-web-devicons",
      },
      config = function() require("latipun.plugins.barbecue").config() end,
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
      lazy = true,
      init = function() require("latipun.plugins.persisted").keybindings() end,
      config = function() require("latipun.plugins.persisted").config() end,
    },
    {
      "stevearc/dressing.nvim",
      event = "VeryLazy",
      config = function() require("latipun.plugins.dressing").config() end,
    },
    {
      "sindrets/diffview.nvim",
      lazy = true,
      cmd = { "DiffviewOpen", "DiffviewFileHistory" },
      init = function() require("latipun.plugins.diffview").keybindings() end,
      config = function() require("latipun.plugins.diffview").config() end,
    },
    {
      "kevinhwang91/nvim-bqf",
      version = "*",
      event = "BufRead",
      config = function() require("latipun.plugins.bqf").config() end,
    },
    {
      "akinsho/git-conflict.nvim",
      version = "*",
      event = "VeryLazy",
      config = function() require("git-conflict").setup() end,
    },
    {
      "kylechui/nvim-surround",
      version = "*",
      event = "BufRead",
      config = function() require("nvim-surround").setup() end,
    },
    {
      "AckslD/nvim-neoclip.lua",
      lazy = true,
      init = function() require("latipun.plugins.neoclip").keybindings() end,
      config = function() require("latipun.plugins.neoclip").config() end,
    },
    {
      "andymass/vim-matchup",
      event = "BufRead",
      init = function() require("latipun.plugins.matchup").config() end,
    },
    {
      "max397574/better-escape.nvim",
      event = "InsertEnter",
      config = function() require("better_escape").setup() end,
    },
    {
      "ThePrimeagen/harpoon",
      lazy = true,
      dependencies = { { "nvim-lua/plenary.nvim" }, { "nvim-lua/popup.nvim" } },
      init = function() require("latipun.plugins.harpoon").keybindings() end,
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v2.x",
      lazy = true,
      cmd = { "Neotree", "NeoTreeRevealToggle" },
      dependencies = { "MunifTanjim/nui.nvim" },
      config = function() require("latipun.plugins.neotree").config() end,
    },
    {
      "folke/noice.nvim",
      version = "*",
      event = "VeryLazy",
      enabled = lvim.builtin.latipun.noice.active,
      dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
      config = function() require("latipun.plugins.noice").config() end,
    },
    {
      "toppair/peek.nvim",
      ft = "markdown",
      enabled = (vim.fn.executable("deno") == 1),
      build = "deno task --quiet build:fast",
    },
    {
      "windwp/nvim-spectre",
      lazy = true,
      init = function() require("latipun.plugins.spectre").keybindings() end,
      config = function() require("latipun.plugins.spectre").config() end,
    },
    {
      "j-hui/fidget.nvim",
      event = "BufRead",
      config = function() require("latipun.plugins.fidget").config() end,
    },
    {
      "smjonas/inc-rename.nvim",
      event = "BufReadPre",
      config = function() require("inc_rename").setup() end,
    },
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      event = "VeryLazy",
    },
    { "alker0/chezmoi.vim", priority = 99999 }, -- BUG: https://github.com/folke/lazy.nvim/discussions/369
    { "famiu/bufdelete.nvim", event = "BufReadPre" },
    { "hrsh7th/cmp-calc", event = { "InsertEnter", "CmdlineEnter" } },
    { "ray-x/cmp-treesitter", event = { "InsertEnter", "CmdlineEnter" } },
    { "camnw/lf-vim" },
    { "wakatime/vim-wakatime" },
  }
end

return M
