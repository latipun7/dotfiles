return {
  {
    "utilyre/barbecue.nvim",
    event = "BufRead",
    dependencies = { "SmiteshP/nvim-navic" },
    init = function()
      LazyVim.lsp.on_attach(function(client, buffer)
        vim.g.navic_silence = true
        if client.supports_method("textDocument/documentSymbol") then require("nvim-navic").attach(client, buffer) end
      end)
    end,
    opts = {
      attach_navic = false,
      exclude_filetypes = {
        "help",
        "startify",
        "dashboard",
        "lazy",
        "neo-tree",
        "neogitstatus",
        "NvimTree",
        "Trouble",
        "alpha",
        "lir",
        "Outline",
        "spectre_panel",
        "toggleterm",
        "DressingSelect",
        "Jaq",
        "harpoon",
        "dap-repl",
        "dap-terminal",
        "dapui_console",
        "dapui_hover",
        "lab",
        "notify",
        "noice",
      },
    },
  },
}
