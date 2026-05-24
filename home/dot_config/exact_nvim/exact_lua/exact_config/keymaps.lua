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
map("v", "p", [["_dp]])
map("v", "P", [["_dP]])

-- Save file
map({ "i", "x", "n", "s" }, "<C-s>", "<Cmd>silent w<CR><Esc>", { desc = "Save file" })

-- Quit
vim.keymap.del("n", "<leader>qq")
map("n", "<leader>q", "<Cmd>confirm qa<CR>", { desc = "Quit all" })

-- UI
map("n", "<leader>ut", "<Cmd>set list!<CR>", { desc = "Toggle hidden characters" })

-- Only for neovide
if vim.g.neovide then
  local function neovideScale(amount)
    local temp = vim.g.neovide_scale_factor + amount
    if temp < 0.5 then return end
    vim.g.neovide_scale_factor = temp
  end

  map("n", "<C-=>", function() neovideScale(0.1) end, { desc = "Increase font size" })
  map("n", "<C-->", function() neovideScale(-0.1) end, { desc = "Decrease font size" })
  map("n", "<C-S-=>", function() vim.g.neovide_scale_factor = 1 end, { desc = "Reset font size" })
end
