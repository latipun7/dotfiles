local disable_function = function(lang)
  local buf_name = vim.fn.expand("%")
  if lang == "yaml" and string.find(buf_name, "chezmoiexternal") then return true end
end

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
      highlight = {
        disable = disable_function,
      },
    },
  },
}
