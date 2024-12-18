-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

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
map("n", "<leader>q", "<Cmd>confirm qa<CR>", { desc = "Quit all" })

-- UI
map("n", "<leader>ut", "<Cmd>set list!<CR>", { desc = "Toggle hidden characters" })
