-- general configs
require("latipun.options").config()

lvim.log.level = "warn"
lvim.format_on_save = true
lvim.transparent_window = true

-- LunarVim builtin configs
lvim.colorscheme = "catppuccin"
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.terminal.open_mapping = "<C-Space>"
lvim.builtin.bufferline.options.sort_by = "insert_after_current"

local alpha_opts = require("latipun.plugins.alpha-dashboard").config()
lvim.builtin.alpha.mode = "custom"
lvim.builtin.alpha.custom = { config = alpha_opts }

lvim.builtin.treesitter.auto_install = true
lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.treesitter.highlight.additional_vim_regex_highlighting = { "yaml" }
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "comment",
  "css",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "tsx",
  "typescript",
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

-- LSP
lvim.lsp.diagnostics.virtual_text = false
vim.list_extend(
  lvim.lsp.automatic_configuration.skipped_servers,
  { "sumneko_lua" }
)

local code_actions = require("lvim.lsp.null-ls.code_actions")
local formatters = require("lvim.lsp.null-ls.formatters")
local linters = require("lvim.lsp.null-ls.linters")

code_actions.setup({
  { name = "eslint_d" },
  { name = "shellcheck" },
})

formatters.setup({
  { name = "prettierd" },
  { command = "shfmt", args = { "-i", "2", "-ci" } },
})

linters.setup({
  { name = "eslint_d" },
  { name = "shellcheck" },
  { name = "zsh" },
})

-- Plugins
require("latipun.plugins").config()

-- Autocommands
require("latipun.autocommands").config()

-- Keybindings
require("latipun.keybindings").config()

-- reload packer compiled without restarting nvim
require("packer").init({
  auto_reload_compiled = true,
})
