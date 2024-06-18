return {
  { "windwp/nvim-ts-autotag", event = "InsertEnter" },
  { "nvim-treesitter/nvim-treesitter-context", event = "LazyFile" },

  -- Tweak treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
      },
    },
  },
}
