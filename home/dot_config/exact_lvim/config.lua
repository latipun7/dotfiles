-- general configs
require("latipun.options").config()
lvim.format_on_save = true
lvim.log.level = "warn"
lvim.transparent_window = true

-- LunarVim builtin configs
lvim.colorscheme = "catppuccin"
lvim.builtin.notify.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.show_icons.git = 1
lvim.builtin.terminal.active = true
lvim.builtin.alpha.mode = "custom"
lvim.builtin.bufferline.options.mode = "buffers"
lvim.builtin.bufferline.options.sort_by = "insert_after_current"

local alpha_opts = require("latipun.plugins.alpha-dashboard").config()
lvim.builtin.alpha["custom"] = { config = alpha_opts }

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
lvim.builtin.treesitter.highlight.enabled = true

lvim.builtin.telescope.defaults.file_ignore_patterns = {
  ".git",
  "node_modules",
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
lvim.lsp.automatic_servers_installation = false
lvim.lsp.diagnostics.virtual_text = false
vim.list_extend(lvim.lsp.override, { "sumneko_lua" })

-- Plugins
require("latipun.plugins").config()

-- Autocommands
require("latipun.autocommands").config()

-- Keybindings
require("latipun.keybindings").config()
