local M = {}

M.config = function()
  local status_ok, blankline = pcall(require, "indent_blankline")
  if not status_ok then
    return
  end

  blankline.setup({
    show_first_indent_level = false,
    use_treesitter = true,
    show_foldtext = false,
    show_current_context = true,
    show_current_context_start = false,
    context_patterns = {
      "class",
      "return",
      "function",
      "method",
      "^if",
      "^do",
      "^switch",
      "^while",
      "jsx_element",
      "^for",
      "^object",
      "^table",
      "block",
      "arguments",
      "if_statement",
      "else_clause",
      "jsx_element",
      "jsx_self_closing_element",
      "try_statement",
      "catch_clause",
      "import_statement",
      "operation_type",
    },
  })
end

return M
