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
lvim.lsp.automatic_servers_installation = true
lvim.lsp.diagnostics.virtual_text = false
vim.list_extend(
  lvim.lsp.automatic_configuration.skipped_servers,
  { "sumneko_lua" }
)

local command_resolver = require("null-ls.helpers.command_resolver")
local formatters = require("lvim.lsp.null-ls.formatters")
local linters = require("lvim.lsp.null-ls.linters")

formatters.setup({
  { command = "shfmt", args = { "-i", "2", "-ci" } },
  {
    command = "prettier",
    dynamic_command = function(params)
      return command_resolver.from_node_modules(params)
        or command_resolver.from_yarn_pnp(params)
        or vim.fn.executable(params.command) == 1 and params.command
    end,
  },
})

linters.setup({
  { name = "shellcheck" },
  {
    command = "eslint",
    dynamic_command = function(params)
      return command_resolver.from_node_modules(params)
        or command_resolver.from_yarn_pnp(params)
        or vim.fn.executable(params.command) == 1 and params.command
    end,
  },
})

-- Plugins
require("latipun.plugins").config()

-- Autocommands
require("latipun.autocommands").config()

-- Keybindings
require("latipun.keybindings").config()
