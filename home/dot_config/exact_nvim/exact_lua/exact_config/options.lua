-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.list = false
opt.listchars = [[space:·,tab:→→,eol:↲,nbsp:␣,trail:•,extends:›,precedes:‹]]
opt.spell = true
opt.spelllang = { "en", "id", "cjk" }
opt.spelloptions = { "camel" }
opt.spellcapcheck = ""
opt.spellfile = { vim.fn.expand(vim.fn.stdpath("config") .. "/spell/mix.utf-8.add") }
opt.wrap = true

if vim.fn.has("wsl") == 1 then
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

if vim.g.neovide then
  -- Transparency
  vim.g.neovide_opacity = 1
  vim.g.neovide_normal_opacity = 0.2

  -- Optional floating window blur
  vim.g.neovide_floating_blur_amount_x = 3.0
  vim.g.neovide_floating_blur_amount_y = 3.0

  -- Extras
  vim.o.guifont = "Cascadia Code NF:h13"
  vim.g.neovide_cursor_vfx_mode = "railgun"
end
