-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local create_aucmd = vim.api.nvim_create_autocmd
local function create_augroup(name) return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true }) end

-- Hide tab line when showing dashboard
-- deps: alpha, bufferline
create_aucmd("User", {
  pattern = "AlphaReady",
  group = create_augroup("toggle_tabline_on_alpha_cmd"),
  callback = function()
    local config = require("bufferline.config")
    local utils = require("bufferline.utils")
    local item_count = config:is_tabline() and utils.get_tab_count() or utils.get_buf_count()
    local status = (config.options.always_show_bufferline or item_count > 1) and 2 or 0
    vim.cmd("set showtabline=0 | autocmd BufUnload <buffer> set showtabline=" .. status)
  end,
})

-- Show alpha dashboard when buffer empty
-- deps: bufdelete, alpha
create_aucmd("User", {
  pattern = { "BDeletePre *" },
  group = create_augroup("alpha_on_empty"),
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local name = vim.api.nvim_buf_get_name(bufnr)

    if name == "" then vim.cmd([[:Alpha | bd#]]) end
  end,
})

-- Disable yaml LS diagnostics on `.chezmoiexternal.yaml` file
create_aucmd({ "BufRead", "BufNewFile" }, {
  pattern = "*chezmoiexternal*",
  callback = function(ev) vim.diagnostic.enable(false, { bufnr = ev.buf }) end,
})
