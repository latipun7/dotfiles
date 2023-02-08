-- general configs
require("latipun.options").config()

lvim.log.level = "warn"
lvim.transparent_window = true
lvim.format_on_save.enabled = true
lvim.reload_config_on_save = false

-- LunarVim builtin configs
require("latipun.lvim_builtin").config()
require("latipun.plugins.lualine").config()
require("latipun.plugins.telescope").config()
require("latipun.plugins.bufferline").config()
require("latipun.plugins.indent_blankline").config()

-- Plugins
require("latipun.plugins").config()

-- Autocommands
require("latipun.autocommands").config()

-- Keybindings
require("latipun.keybindings").config()

-- LSP
local code_actions = require("lvim.lsp.null-ls.code_actions")
local formatters = require("lvim.lsp.null-ls.formatters")
local linters = require("lvim.lsp.null-ls.linters")

lvim.lsp.diagnostics.virtual_text = false
lvim.lsp.installer.setup.automatic_installation = true
lvim.lsp.buffer_mappings.normal_mode["gp"] = {
  function() require("latipun.peek").Peek("definition") end,
  "Peek definition",
}
lvim.lsp.null_ls.setup = {
  should_attach = function(bufnr)
    return not vim.api.nvim_buf_get_name(bufnr):match("tmpl$")
  end,
}

vim.list_extend(
  lvim.lsp.automatic_configuration.skipped_filetypes,
  { "css", "scss", "c" }
)
vim.list_extend(
  lvim.lsp.automatic_configuration.skipped_servers,
  { "sumneko_lua", "powershell_es" }
)

code_actions.setup({
  { name = "eslint_d" },
  { name = "shellcheck" },
})

formatters.setup({
  { name = "prettierd" },
  { name = "rustfmt" },
  { command = "shfmt", args = { "-i", "2", "-ci" } },
})

linters.setup({
  { name = "eslint_d" },
  { name = "shellcheck" },
  { name = "zsh" },
})
