-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  ---@diagnostic disable-next-line
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then opts.remap = nil end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- Movement in insert mode
map("i", "<C-h>", "<C-o>h")
map("i", "<C-j>", "<C-o>j")
map("i", "<C-k>", "<C-o>k")
map("i", "<C-l>", "<C-o>l")

-- Paste still contains yanked words
map("v", "p", [["_dP]])
map("v", "P", [["_dP]])

-- Save file
map({ "i", "x", "n", "s" }, "<C-s>", "<Cmd>silent w<CR><Esc>", { desc = "Save file" })

-- Quit
vim.keymap.del("n", "<leader>qq")
map("n", "<leader>q", "<Cmd>confirm qa<CR>", { desc = "󰗼  Quit all" })

-- Search
map("n", "<leader>snn", "<Cmd>Telescope notify<CR>", { desc = "List notify" })

-- UI
map("n", "<leader>ut", "<Cmd>set list!<CR>", { desc = " Toggle hidden characters" })
