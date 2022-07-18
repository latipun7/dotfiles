local M = {}

M.config = function()
  local status_ok, catppuccin = pcall(require, "catppuccin")
  if not status_ok then
    return
  end

  catppuccin.setup({
    transparent_background = lvim.transparent_window,
    term_colors = true,
    integrations = {
      lsp_trouble = true,
      cmp = true,
      lsp_saga = true,
      gitgutter = true,
      gitsigns = true,
      telescope = true,
      nvimtree = {
        enabled = true,
        show_root = true,
        transparent_panel = lvim.transparent_window,
      },
      neotree = {
        enabled = true,
        show_root = true,
        transparent_panel = lvim.transparent_window,
      },
      which_key = true,
      indent_blankline = {
        enabled = true,
        colored_indent_levels = true,
      },
      dashboard = true,
      neogit = true,
      vim_sneak = true,
      fern = true,
      barbar = true,
      bufferline = true,
      markdown = true,
      lightspeed = false,
      ts_rainbow = true,
      hop = true,
      notify = true,
      telekasten = true,
      symbols_outline = true,
      mini = true,
    },
  })
end

return M
