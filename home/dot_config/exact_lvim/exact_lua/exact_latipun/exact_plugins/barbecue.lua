local M = {}

M.config = function()
  local status_ok, barbecue = pcall(require, "barbecue")
  if not status_ok then return end

  vim.api.nvim_clear_autocmds({ pattern = "*", group = "_winbar" })

  barbecue.setup({
    theme = lvim.colorscheme,
    exclude_filetypes = {
      "help",
      "startify",
      "dashboard",
      "lazy",
      "neo-tree",
      "neogitstatus",
      "NvimTree",
      "Trouble",
      "alpha",
      "lir",
      "Outline",
      "spectre_panel",
      "toggleterm",
      "DressingSelect",
      "Jaq",
      "harpoon",
      "dap-repl",
      "dap-terminal",
      "dapui_console",
      "dapui_hover",
      "lab",
      "notify",
      "noice",
    },
  })
end

return M
