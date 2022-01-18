-- :help options
local options = {
  autoindent = true,
  backup = false,
  backspace = {'indent', 'eol', 'start'},
  cindent = true,
  clipboard = 'unnamedplus',
  cmdheight = 2,
  completeopt = { 'menuone', 'noselect' },
  conceallevel = 0,
  cursorline = true,
  expandtab = true,
  fileencoding = 'utf-8',
  guifont = 'Delugia:h19,Delugia_Mono:h19,monospace:h19',
  hlsearch = true,
  ignorecase = true,
  mouse = 'a',
  number = true,
  numberwidth = 4,
  pumheight = 10,
  relativenumber = false,
  shiftround = true,
  shiftwidth = 2,
  showmode = false,
  showtabline = 2,
  signcolumn = 'yes',
  smartcase = true,
  smartindent = true,
  smarttab = true,
  softtabstop = 2,
  splitbelow = true,
  splitright = true,
  swapfile = false,
  tabstop = 2,
  timeoutlen = 1000,
  undofile = true,
  updatetime = 300,
  wrap = true,
  writebackup = false,
}

for key, value in pairs(options) do
  vim.opt[key] = value
end

vim.opt.shortmess:append('c')
vim.opt.formatoptions:remove({ 'c', 'r', 'o' })
vim.cmd('set whichwrap+=<,>,[,],h,l')
vim.cmd('set iskeyword+=-')

if vim.fn.has('termguicolors') == 1 then
  vim.opt.termguicolors = true
end
