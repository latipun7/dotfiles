return {
  -- Tweak LazyVim's LSP related plugins
  {
    "folke/noice.nvim",
    opts = {
      presets = { lsp_doc_border = true },
    },
  },
  {
    "folke/lazydev.nvim",
    opts = {
      library = {
        { path = "~/.config/yazi/plugins/types.yazi/", words = { "ya%." } },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ui = { border = "rounded", height = 0.8 }
      vim.list_extend(opts.ensure_installed, {
        "eslint_d",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = true },
      servers = {
        taplo = {
          filetypes = { "toml" },
          -- IMPORTANT: this is required for taplo LSP to work in non-git repositories
          root_dir = require("lspconfig.util").root_pattern("*.toml", ".git"),
        },
      },
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
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        rust = { "rustfmt" },
      },
    },
  },
}
