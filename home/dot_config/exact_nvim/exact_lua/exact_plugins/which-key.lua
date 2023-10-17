return {
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.icons = { group = "" }
      opts.window = { border = "single" }

      opts.defaults["g"] = { name = " Go to" }
      opts.defaults["]"] = { name = "󰒭 Next" }
      opts.defaults["["] = { name = "󰒮 Prev" }
      opts.defaults["<leader><tab>"] = { name = "󰓩  Tabs" }
      opts.defaults["<leader>b"] = { name = "  Buffer" }
      opts.defaults["<leader>c"] = { name = "  Code" }
      opts.defaults["<leader>d"] = { name = "  Debug" }
      opts.defaults["<leader>da"] = { name = "󰘚  Adapters" }
      opts.defaults["<leader>f"] = { name = "󰈞  File/find" }
      opts.defaults["<leader>g"] = { name = "󰊢  Git" }
      opts.defaults["<leader>gh"] = { name = "  Hunks" }
      opts.defaults["<leader>S"] = { name = "󰗼  Session" }
      opts.defaults["<leader>s"] = { name = "  Search" }
      opts.defaults["<leader>sn"] = { name = "  Notifications" }
      opts.defaults["<leader>t"] = { name = "󰙨  Test" }
      opts.defaults["<leader>u"] = { name = "󱄄  UI" }
      opts.defaults["<leader>w"] = { name = "󱇛  Windows" }
      opts.defaults["<leader>x"] = { name = "󰓙  Diagnostics/quickfix" }
      opts.defaults["<leader>q"] = {}
    end,
  },
}
