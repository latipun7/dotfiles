return {
  {
    "neovim/nvim-lspconfig",
    -- LSP keymaps
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- stylua: ignore start
      keys[#keys + 1] = { "<C-k>", false, mode = "i" }
      keys[#keys + 1] = { "<C-g>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" }
      -- stylua: ignore end
    end,
  },
}
