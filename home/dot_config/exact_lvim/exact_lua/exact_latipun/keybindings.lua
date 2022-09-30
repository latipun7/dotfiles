local M = {}
local expr_opts = { noremap = true, expr = true, silent = true }

M.set_terminal_keymaps = function()
  local opts = { noremap = true, silent = true }

  vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", "<C-h>", opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", "<C-j>", opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", "<C-k>", opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", "<C-l>", opts)
end

M.config = function()
  -- keymappings [view all the defaults by pressing <Leader>Lk]
  lvim.leader = "space"

  -- ▄▖ ▌ ▌▘▗ ▘      ▜   ▌     ▌ ▘   ▌▘
  -- ▌▌▛▌▛▌▌▜▘▌▛▌▛▌▀▌▐   ▙▘█▌▌▌▛▌▌▛▌▛▌▌▛▌▛▌▛▘
  -- ▛▌▙▌▙▌▌▐▖▌▙▌▌▌█▌▐▖  ▛▖▙▖▙▌▙▌▌▌▌▙▌▌▌▌▙▌▄▌
  --                         ▄▌          ▄▌

  lvim.keys.normal_mode["<C-s>"] = "<Cmd>silent w<CR>"

  -- Move virtual lines (lines that wrap)
  lvim.keys.normal_mode["j"] = { [[v:count == 0 ? "gj" : "j"]], expr_opts }
  lvim.keys.normal_mode["k"] = { [[v:count == 0 ? "gk" : "k"]], expr_opts }

  -- Movement in insert mode
  lvim.keys.insert_mode["<C-h>"] = "<C-o>h"
  lvim.keys.insert_mode["<C-j>"] = "<C-o>j"
  lvim.keys.insert_mode["<C-k>"] = "<C-o>k"
  lvim.keys.insert_mode["<C-l>"] = "<C-o>l"

  -- Paste still contains yanked words
  lvim.keys.visual_mode["p"] = [["_dP]]
  lvim.keys.visual_mode["P"] = [["_dP]]

  -- Bufferline
  lvim.keys.normal_mode.L = "<Cmd>BufferLineCycleNext<CR>"
  lvim.keys.normal_mode.H = "<Cmd>BufferLineCyclePrev<CR>"

  -- ▖  ▖▌ ▘  ▌   ▌       ▌     ▌ ▘   ▌▘
  -- ▌▞▖▌▛▌▌▛▘▛▌▄▖▙▘█▌▌▌  ▙▘█▌▌▌▛▌▌▛▌▛▌▌▛▌▛▌▛▘
  -- ▛ ▝▌▌▌▌▙▖▌▌  ▛▖▙▖▙▌  ▛▖▙▖▙▌▙▌▌▌▌▙▌▌▌▌▙▌▄▌
  --                  ▄▌      ▄▌          ▄▌

  if lvim.builtin.nvimtree.active == true then
    lvim.builtin.nvimtree.on_config_done = function()
      lvim.builtin.which_key.mappings.e =
        { "<Cmd>NvimTreeToggle<CR>", "ﰤ Explorer" }
    end
  else
    lvim.builtin.which_key.mappings.e =
      { "<Cmd>NeoTreeRevealToggle<CR>", "ﰤ Explorer" }
  end

  lvim.builtin.which_key.vmappings["/"] = {
    "<Plug>(comment_toggle_linewise_visual)",
    " Toggle comment linewise",
  }

  lvim.builtin.which_key.mappings["/"] = {
    "<Plug>(comment_toggle_linewise_current)",
    " Toggle comment current line",
  }
  lvim.builtin.which_key.mappings[";"] = { "<Cmd>Alpha<CR>", "﵁ Dashboard" }
  lvim.builtin.which_key.mappings.f = {
    require("lvim.core.telescope.custom-finders").find_project_files,
    " Find File",
  }

  lvim.builtin.which_key.mappings.h =
    { "<Cmd>nohlsearch<CR>", " No Highlight" }
  lvim.builtin.which_key.mappings.q =
    { "<Cmd>lua require('lvim.utils.functions').smart_quit()<CR>", " Quit" }
  lvim.builtin.which_key.mappings.w = { "<Cmd>silent w!<CR>", " Save" }

  lvim.builtin.which_key.mappings.t =
    { "<Cmd>set list!<CR>", " Toggle hidden characters" }
  lvim.builtin.which_key.mappings.F =
    { "<Cmd>LvimToggleFormatOnSave<CR>", " Toggle format on save" }
  lvim.builtin.which_key.mappings.c = { "<Cmd>Bdelete<CR>", " Close buffer" }

  lvim.builtin.which_key.mappings.b = {
    name = " Buffers",
    b = { "<Cmd>b#<CR>", " Previous" },
    c = { [[<Cmd>silent! %bdelete|e#|bdelete#<CR>]], " Close all but this" },
    D = { "<Cmd>BufferLineSortByDirectory<CR>", " Sort by directory" },
    e = { "<Cmd>BufferLinePickClose<CR>", "ﲨ Pick which buffer to close" },
    f = { "<Cmd>Telescope buffers<CR>", " Find" },
    h = { "<Cmd>BufferLineCloseLeft<CR>", " Close all to the left" },
    j = { "<Cmd>BufferLinePick<CR>", " Jump" },
    L = { "<Cmd>BufferLineSortByExtension<CR>", " Sort by language" },
    l = { "<Cmd>BufferLineCloseRight<CR>", " Close all to the right" },
    p = { "<Cmd>BufferLineTogglePin<CR>", " Toggle pin" },
    w = { "<Cmd>bufdo Bdelete<CR>", " Close all buffers" },
  }

  -- Git
  lvim.builtin.which_key.mappings.g = {
    name = " Git",
    j = { "<Cmd>lua require('gitsigns').next_hunk()<CR>", " Next hunk" },
    k = { "<Cmd>lua require('gitsigns').prev_hunk()<CR>", " Previous hunk" },
    l = { "<Cmd>lua require('gitsigns').blame_line()<CR>", "ﯙ Blame" },
    p = {
      "<Cmd>lua require('gitsigns').preview_hunk()<CR>",
      " Preview hunk",
    },
    r = { "<Cmd>lua require('gitsigns').reset_hunk()<CR>", " Reset hunk" },
    R = {
      "<Cmd>lua require('gitsigns').reset_buffer()<CR>",
      " Reset buffer",
    },
    s = { "<Cmd>lua require('gitsigns').stage_hunk()<CR>", " Stage hunk" },
    u = {
      "<Cmd>lua require('gitsigns').undo_stage_hunk()<CR>",
      " Undo stage hunk",
    },
    o = { "<Cmd>Telescope git_status<CR>", " Open changed file" },
    b = { "<Cmd>Telescope git_branches<CR>", " Checkout branch" },
    c = { "<Cmd>Telescope git_commits<CR>", " Checkout commit" },
    C = {
      "<Cmd>Telescope git_bcommits<CR>",
      "ﰖ Checkout commit (for current file)",
    },
  }

  lvim.builtin.which_key.mappings.L.name = " LunarVim"
  lvim.builtin.which_key.mappings.l.name = " LSP"
  lvim.builtin.which_key.mappings.p.name = " Packer"
  lvim.builtin.which_key.mappings.s.name = " Search"

  -- LSP - Peek
  lvim.builtin.which_key.mappings["lp"] = {
    name = "Peek",
    d = {
      "<Cmd>lua require('latipun.peek').Peek('definition')<CR>",
      "Definition",
    },
    t = {
      "<Cmd>lua require('latipun.peek').Peek('typeDefinition')<CR>",
      "Type definition",
    },
    i = {
      "<Cmd>lua require('latipun.peek').Peek('implementation')<CR>",
      "Implementation",
    },
  }

  -- Treesitter
  lvim.builtin.which_key.mappings.T = {
    name = " Treesitter",
    i = { "<Cmd>TSInstallInfo<CR>", "Info" },
    u = { "<Cmd>TSUpdateSync<CR>", "Update" },
    h = { "<Cmd>TSBufToggle highlight<CR>", "Toggle highlight" },
  }
end

return M
