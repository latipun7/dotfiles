local M = {}

M.config = function()
  local status_ok, catppuccin = pcall(require, "catppuccin")
  if not status_ok then
    return
  end

  catppuccin.setup({
    transparent_background = lvim.transparent_window,
    term_colors = true,
    styles = {
      comments = "italic",
      functions = "italic",
      keywords = "italic",
      strings = "NONE",
      variables = "italic",
    },
    integrations = {
      treesitter = true,
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = "italic",
          hints = "italic",
          warnings = "italic",
          information = "italic",
        },
        underlines = {
          errors = "underline",
          hints = "underline",
          warnings = "underline",
          information = "underline",
        },
      },
      lsp_trouble = true,
      cmp = true,
      lsp_saga = true,
      gitgutter = true,
      gitsigns = true,
      telescope = true,
      nvimtree = {
        enabled = true,
        show_root = true,
        transparent_panel = true,
      },
      neotree = {
        enabled = true,
        show_root = true,
        transparent_panel = true,
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
    },
  })
end

return M
