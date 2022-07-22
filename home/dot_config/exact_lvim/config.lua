-- general configs
require("latipun.options").config()

lvim.log.level = "warn"
lvim.format_on_save = true
lvim.transparent_window = true

-- LunarVim builtin configs
lvim.colorscheme = "catppuccin"
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.bufferline.options.sort_by = "insert_after_current"

local alpha_opts = require("latipun.plugins.alpha-dashboard").config()
lvim.builtin.alpha.mode = "custom"
lvim.builtin.alpha["custom"] = { config = alpha_opts }

lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "yaml",
}

lvim.builtin.project.detection_methods = { "pattern" }
lvim.builtin.project.show_hidden = true
lvim.builtin.project.patterns = {
  ".git",
  ".editorconfig",
  ".hg",
  ".bzr",
  ".svn",
  "_darcs",
  "Makefile",
  "package.json",
}

lvim.builtin.telescope.defaults.file_ignore_patterns = {
  ".git",
  "node_modules",
}

-- LSP
lvim.lsp.automatic_servers_installation = true
lvim.lsp.diagnostics.virtual_text = false
vim.list_extend(
  lvim.lsp.automatic_configuration.skipped_servers,
  { "sumneko_lua" }
)

local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
  { name = "prettier" },
  { command = "shfmt", args = { "-i", "2", "-ci" } },
})

local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
  { name = "eslint" },
  { name = "shellcheck" },
})

-- Plugins
require("latipun.plugins").config()

-- Autocommands
require("latipun.autocommands").config()

-- Keybindings
require("latipun.keybindings").config()
