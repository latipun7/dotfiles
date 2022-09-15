local M = {}

M.config = function()
  lvim.builtin.global_statusline = true

  lvim.builtin.bufferline.options.sort_by = "insert_after_current"

  lvim.builtin.notify.active = true

  lvim.builtin.terminal.active = true
  lvim.builtin.terminal.open_mapping = "<C-Space>"
  lvim.builtin.terminal.execs = { { "lazygit", "<Leader>gg", " LazyGit" } }

  local alpha_opts = require("latipun.plugins.alpha-dashboard").config()
  lvim.builtin.alpha.mode = "custom"
  lvim.builtin.alpha.custom = { config = alpha_opts }

  lvim.builtin.treesitter.auto_install = true
  lvim.builtin.treesitter.highlight.enabled = true
  lvim.builtin.treesitter.highlight.additional_vim_regex_highlighting =
    { "yaml" }
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
    "regex",
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
end

return M
