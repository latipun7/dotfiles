-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.spell = true
opt.spelllang = { "en", "id", "cjk" }
opt.spelloptions = { "camel" }
opt.spellcapcheck = ""
opt.spellfile = { vim.fn.expand(vim.fn.stdpath("config") .. "/spell/mix.utf-8.add") }
