local M = {}

M.config = function()
  local status_ok, catppuccin = pcall(require, "catppuccin")
  if not status_ok then
    return
  end

  catppuccin.setup({
    transparent_background = lvim.transparent_window,
    term_colors = true,
    compile = { enabled = true },
    integrations = {
      treesitter = true,
      cmp = true,
      gitsigns = true,
      telescope = true,
      nvimtree = true,
      which_key = true,
      hop = true,
      notify = true,
      symbols_outline = true,
      indent_blankline = { enabled = true, colored_indent_levels = true },
      bufferline = { enabled = true, italics = true, bolds = true },
    },
  })

  vim.g.catppuccin_flavour = "mocha"
  vim.cmd([[colorscheme catppuccin]])
end

return M
