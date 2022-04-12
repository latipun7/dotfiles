local formatters = require("lvim.lsp.null-ls.formatters")
local linters = require("lvim.lsp.null-ls.linters")

formatters.setup({
  {
    exe = "shfmt",
    args = { "-i", "2", "-ci" },
  },
})

linters.setup({ { exe = "shellcheck" } })
