return {
  -- Tweak LazyVim's LSP related plugins
  {
    "folke/noice.nvim",
    opts = {
      presets = { lsp_doc_border = true },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ui = { border = "rounded", height = 0.8 }
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "shellcheck",
        "shfmt",
        "markdownlint",
        "eslint_d",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = true },
    },
  },
  {
    "simrat39/rust-tools.nvim",
    optional = true,
    opts = {
      tools = {
        inlay_hints = { auto = false }, -- use native neovim lsp instead
      },
    },
  },

  -- Linters & Formatters
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = { "markdownlint" },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        rust = { "rustfmt" },
      },
    },
  },
}
