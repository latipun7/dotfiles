local term_opts = { silent = true }
local opts = { noremap = true, silent = true }
local expr_opts = { noremap = true, silent = true, expr = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

-- Remap space as leader key
keymap('', '<Space>', '<NOP>', opts)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--------------------------
----      Normal      ----
--------------------------

keymap('n', '<Leader>e', ':Lexplore 30<CR>', opts)

-- Move text up and down
keymap('n', '<A-j>', ':move .+1<CR>', opts)
keymap('n', '<A-k>', ':move .-2<CR>', opts)

-- Move virtual lines (lines that wrap)
keymap('n', 'j', 'v:count == 0 ? "gj" : "j"', expr_opts)
keymap('n', 'k', 'v:count == 0 ? "gk" : "k"', expr_opts)

-- Better window navigation
keymap('n', '<C-h>', '<C-w>h', opts)
keymap('n', '<C-j>', '<C-w>j', opts)
keymap('n', '<C-k>', '<C-w>k', opts)
keymap('n', '<C-l>', '<C-w>l', opts)

-- Resize with arrows
keymap('n', '<C-Up>', ':resize +2<CR>', opts)
keymap('n', '<C-Down>', ':resize -2<CR>', opts)
keymap('n', '<C-Left>', ':vertical resize -2<CR>', opts)
keymap('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-- Navigate buffers
keymap('n', 'L', ':bnext<CR>', opts)
keymap('n', 'H', ':bprevious<CR>', opts)

-- Shortcut
keymap('n', '<Leader>/', ':noh<CR>', opts)
keymap('n', '<Leader>r', ':reg<CR>', opts)

-- Open new line below and above current line
keymap('n', '<Leader>o', 'o<Esc>', opts)
keymap('n', '<Leader>O', 'O<Esc>', opts)

-- Action on all lines
keymap('n', '<Leader>ad', ':%d<CR>', opts)
keymap('n', '<Leader>ay', ':%y<CR>', opts)

-- Save
keymap('n', '<Leader>w', ':w<CR>', opts)
keymap('n', '<Leader>W', ':wa<CR>', opts)

-- Quit
keymap('n', '<Leader>q', ':q<CR>', opts)
keymap('n', '<Leader>Q', ':qa<CR>', opts)

----------------------------
----       Insert       ----
----------------------------

-- Back to normal mode
keymap('i', 'jj', '<Esc>', opts)

-- Movement in insert mode
keymap('i', '<C-h>', '<C-o>h', opts)
keymap('i', '<C-j>', '<C-o>j', opts)
keymap('i', '<C-k>', '<C-o>k', opts)
keymap('i', '<C-l>', '<C-o>l', opts)

-----------------------------
----  Visual and Select  ----
-----------------------------

-- Stay in indent mode
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

-- Move text up and down
keymap('v', '<A-j>', ':m .+1<CR>gv', opts)
keymap('v', '<A-k>', ':m .-2<CR>gv', opts)

-- Paste still contains yanked word
keymap('v', 'p', '"_dP', opts)

----------------------------
----      Terminal      ----
----------------------------

-- Better terminal navigation
keymap('t', '<C-h>', [[<C-\><C-n><C-w>h]], term_opts)
keymap('t', '<C-j>', [[<C-\><C-n><C-w>j]], term_opts)
keymap('t', '<C-k>', [[<C-\><C-n><C-w>k]], term_opts)
keymap('t', '<C-l>', [[<C-\><C-n><C-w>l]], term_opts)

-- Turn terminal to normal mode
keymap('t', 'jj', [[<C-\><C-n>]], term_opts)

----------------------------
----   Command-line     ----
----------------------------

-- Back to normal mode
keymap('c', 'jj', '<C-c>', opts)
