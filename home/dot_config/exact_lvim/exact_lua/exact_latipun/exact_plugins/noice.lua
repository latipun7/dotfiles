local M = {}

M.config = function()
  local status_ok, noice = pcall(require, "noice")
  if not status_ok then return end

  local focused = true
  vim.api.nvim_create_autocmd("FocusGained", {
    callback = function() focused = true end,
  })
  vim.api.nvim_create_autocmd("FocusLost", {
    callback = function() focused = false end,
  })

  noice.setup({
    lsp = {
      progress = { enabled = false },
      -- override markdown rendering so that cmp and other plugins use Treesitter
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      command_palette = true,
      long_message_to_split = true,
      lsp_doc_border = true,
    },
    views = { split = { enter = true } },
    cmdline = {
      format = {
        filter = { pattern = "^:%s*!", icon = "", lang = "bash" },
        rename = {
          pattern = "^:%s*IncRename%s+",
          icon = "",
          opts = {
            relative = "cursor",
            size = { min_width = 21 },
            position = { row = -2, col = 0 },
          },
        },
        input = {
          opts = {
            relative = "cursor",
            size = { min_width = 21 },
            position = { row = -2, col = 0 },
          },
        },
      },
    },
    routes = {
      {
        filter = {
          cond = function() return not focused end,
        },
        view = "notify_send",
        opts = { stop = false },
      },
      {
        filter = {
          event = "msg_show",
          find = "%d+L, %d+B",
        },
        view = "mini",
      },
      {
        filter = {
          event = "msg_show",
          find = "; before #",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          find = "; after #",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          find = " lines, ",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          find = "go up one level",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          find = "yanked",
        },
        opts = { skip = true },
      },
      {
        filter = { find = "No active Snippet" },
        opts = { skip = true },
      },
      {
        view = "split",
        filter = { event = "msg_show", min_height = 10 },
      },
      {
        view = "notify",
        filter = {
          event = "msg_show",
          kind = { "", "echo", "echomsg" },
        },
        opts = { replace = true, merge = true, title = "" },
      },
      {
        view = "notify",
        filter = { event = "msg_showmode" },
        opts = { title = "" },
      },
    },
  })

  -- LSP Hover scrolling
  vim.keymap.set("n", "<c-f>", function()
    if not require("noice.lsp").scroll(4) then return "<c-f>" end
  end, { silent = true, expr = true })

  vim.keymap.set("n", "<c-b>", function()
    if not require("noice.lsp").scroll(-4) then return "<c-b>" end
  end, { silent = true, expr = true })
end

return M
