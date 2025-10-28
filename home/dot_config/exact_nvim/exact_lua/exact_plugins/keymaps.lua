return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            { "<C-k>", false, mode = "i" },
            {
              "<C-g>",
              "<Cmd>lua vim.lsp.buf.signature_help()<CR>",
              mode = "i",
              desc = "Signature Help",
              has = "Signature Help",
            },
          },
        },
      },
    },
  },
}
