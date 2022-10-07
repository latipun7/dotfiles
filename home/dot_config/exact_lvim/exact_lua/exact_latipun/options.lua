local M = {}

M.config = function()
  local options = {
    autoindent = true,
    backup = false,
    backspace = { "indent", "eol", "start" },
    cindent = true,
    clipboard = "unnamedplus",
    cmdheight = 2,
    completeopt = { "menuone", "noselect" },
    conceallevel = 0,
    cursorline = true,
    expandtab = true,
    fileencoding = "utf-8",
    fillchars = {
      fold = " ",
      eob = " ",
      diff = "╱", -- alternatives = ⣿ ░ ─
      msgsep = "‾",
      foldopen = "▾",
      foldsep = "│",
      foldclose = "▸",
      horiz = "━",
      horizup = "┻",
      horizdown = "┳",
      vert = "┃",
      vertleft = "┫",
      vertright = "┣",
      verthoriz = "╋",
    },
    foldexpr = "nvim_treesitter#foldexpr()",
    foldlevel = 4,
    foldmethod = "expr",
    foldminlines = 1,
    foldnestmax = 3,
    foldtext = [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']],
    listchars = [[space:·,tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:›,precedes:‹]],
    guifont = "Delugia:h13,monospace:h13",
    hlsearch = true,
    ignorecase = true,
    mouse = "a",
    number = true,
    numberwidth = 4,
    pumheight = 10,
    relativenumber = true,
    sessionoptions = "buffers,curdir,folds,help,tabpages,winpos,winsize",
    shiftround = true,
    shiftwidth = 2,
    showmode = false,
    showtabline = 2,
    signcolumn = "yes",
    smartcase = true,
    smartindent = true,
    smarttab = true,
    softtabstop = 2,
    splitbelow = true,
    splitright = true,
    swapfile = false,
    tabstop = 2,
    timeoutlen = 250,
    undofile = true,
    updatetime = 300,
    wrap = true,
    writebackup = false,
  }

  for key, value in pairs(options) do
    vim.opt[key] = value
  end

  ---@diagnostic disable-next-line
  vim.opt.shortmess:append("W")
  vim.opt.formatoptions:remove({ "c", "r", "o" })

  vim.cmd("set whichwrap+=<,>,[,],h,l")
  vim.cmd("set iskeyword+=-")

  if vim.fn.has("termguicolors") == 1 then vim.opt.termguicolors = true end
end

return M
