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
    guifont = "monospace:h13,Symbols Nerd Font:h13",
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

  vim.opt.shortmess:append("W")

  vim.cmd("set whichwrap+=<,>,[,],h,l")
  vim.cmd("set iskeyword+=-")

  if vim.fn.has("termguicolors") == 1 then vim.opt.termguicolors = true end
end

function M.maximize_current_split()
  local cur_win = vim.api.nvim_get_current_win()
  vim.api.nvim_set_var("non_float_total", 0)
  vim.cmd("windo if &buftype != 'nofile' | let g:non_float_total += 1 | endif")
  vim.api.nvim_set_current_win(cur_win or 0)
  if vim.api.nvim_get_var("non_float_total") == 1 then
    if vim.fn.tabpagenr("$") == 1 then return end
    vim.cmd("tabclose")
  else
    local last_cursor = vim.api.nvim_win_get_cursor(0)
    vim.cmd("tabedit %:p")
    vim.api.nvim_win_set_cursor(0, last_cursor)
  end
end

return M
