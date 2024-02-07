-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.spell = true
opt.spelllang = { "en", "id", "cjk" }
opt.spelloptions = { "camel" }
opt.spellcapcheck = ""
opt.spellfile = { vim.fn.expand(vim.fn.stdpath("config") .. "/spell/mix.utf-8.add") }

if vim.fn.has("wsl") == 1 then
  print("testing")
  vim.g.clipboard = {
    name = "WSL",
    copy = {
      ["+"] = { "clip.exe" },
      ["*"] = { "clip.exe" },
    },
    paste = {
      ["+"] = {
        "powershell.exe",
        "-noprofile",
        "-c",
        '[Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      },
      ["*"] = {
        "powershell.exe",
        "-noprofile",
        "-c",
        '[Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      },
    },
    cache_enabled = false,
  }
end
