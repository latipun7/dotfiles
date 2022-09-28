local M = {}

M.config = function()
  local status_ok, catppuccin = pcall(require, "catppuccin")
  if not status_ok then
    return
  end

  catppuccin.setup({
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
      neotree = true,
      notify = true,
      illuminate = true,
      symbols_outline = true,
      indent_blankline = { enabled = true, colored_indent_levels = true },
      navic = { enabled = true, custom_bg = "NONE" },
    },
  })

  vim.cmd("colorscheme catppuccin")
end

return M
