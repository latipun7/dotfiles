local M = {}
local expr_opts = { noremap = true, expr = true, silent = true }

M.set_terminal_keymaps = function()
  local opts = { noremap = true, silent = true }

  vim.api.nvim_buf_set_keymap(0, "t", "<A-Esc>", [[<C-\><C-n>]], opts)
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

  lvim.keys.normal_mode["<CR>"] = {
    "<Cmd>lua require('latipun.options').maximize_current_split()<CR>",
    { noremap = true, silent = true, nowait = true },
  }

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
      lvim.builtin.which_key.mappings.e = { "<Cmd>NvimTreeToggle<CR>", "󰜦 Explorer" }
    end
  else
    lvim.builtin.which_key.mappings.e = { "<Cmd>NeoTreeRevealToggle<CR>", "󰜦 Explorer" }
  end

  lvim.builtin.which_key.mappings.P = {
    "<Cmd>lua require('peek').open()<CR>",
    " Previewer open",
  }

  lvim.builtin.which_key.vmappings["/"] = {
    "<Plug>(comment_toggle_linewise_visual)",
    " Toggle comment linewise",
  }

  lvim.builtin.which_key.mappings["/"] = {
    "<Plug>(comment_toggle_linewise_current)",
    " Toggle comment current line",
  }
  lvim.builtin.which_key.mappings[";"] = { "<Cmd>Alpha<CR>", "󰡃 Dashboard" }
  lvim.builtin.which_key.mappings.f = {
    require("latipun.plugins.telescope").find_project_files,
    "󰈞 Find File",
  }

  lvim.builtin.which_key.mappings.h = { "<Cmd>nohlsearch<CR>", "󰉃 No Highlight" }
  lvim.builtin.which_key.mappings.q = { "<Cmd>confirm q<CR>", "󰗼 Quit" }
  lvim.builtin.which_key.mappings.w = { "<Cmd>silent w!<CR>", " Save" }

  lvim.builtin.which_key.mappings.t = { "<Cmd>set list!<CR>", " Toggle hidden characters" }
  lvim.builtin.which_key.mappings.F = { "<Cmd>LvimToggleFormatOnSave<CR>", "󰉼 Toggle format on save" }
  lvim.builtin.which_key.mappings.c = { "<Cmd>Bdelete<CR>", " Close buffer" }

  lvim.builtin.which_key.mappings.b = {
    name = " Buffers",
    b = { "<Cmd>b#<CR>", " Previous" },
    c = { [[<Cmd>silent! %bdelete|e#|bdelete#<CR>]], " Close all but this" },
    D = { "<Cmd>BufferLineSortByDirectory<CR>", " Sort by directory" },
    e = { "<Cmd>BufferLinePickClose<CR>", "󰞪 Pick which buffer to close" },
    f = { "<Cmd>Telescope buffers<CR>", "󰍉 Find" },
    h = { "<Cmd>BufferLineCloseLeft<CR>", " Close all to the left" },
    j = { "<Cmd>BufferLinePick<CR>", "󰀜 Jump" },
    L = { "<Cmd>BufferLineSortByExtension<CR>", " Sort by language" },
    l = { "<Cmd>BufferLineCloseRight<CR>", " Close all to the right" },
    p = { "<Cmd>BufferLineTogglePin<CR>", " Toggle pin" },
    w = { "<Cmd>bufdo Bdelete<CR>", " Close all buffers" },
  }

  -- Git
  lvim.builtin.which_key.mappings.g = {
    name = " Git",
    g = {
      "<Cmd>lua require('lvim.core.terminal').lazygit_toggle()<CR>",
      " LazyGit",
    },
    j = {
      "<Cmd>lua require('gitsigns').next_hunk({navigation_message = false})<CR>",
      " Next hunk",
    },
    k = {
      "<Cmd>lua require('gitsigns').prev_hunk({navigation_message = false})<CR>",
      " Previous hunk",
    },
    l = { "<Cmd>lua require('gitsigns').blame_line()<CR>", " Blame" },
    p = {
      "<Cmd>lua require('gitsigns').preview_hunk()<CR>",
      "󰆊 Preview hunk",
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
      "󰜘 Checkout commit (for current file)",
    },
  }

  lvim.builtin.which_key.mappings.d.name = " Debug"
  lvim.builtin.which_key.mappings.L.name = " LunarVim"
  lvim.builtin.which_key.mappings.l.name = " LSP"
  lvim.builtin.which_key.mappings.p.name = "󰏖 Plugins"
  lvim.builtin.which_key.mappings.s.name = " Search"

  lvim.builtin.which_key.mappings.Ln = { "<Cmd>Telescope notify<CR>", "View notifications" }

  -- LSP - Peek
  lvim.builtin.which_key.mappings.lp = {
    name = " Peek",
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

  -- LSP - Trouble
  lvim.builtin.which_key.mappings.lt = {
    name = " Trouble",
    t = { "<Cmd>TroubleToggle<CR>", "Toggle Views" },
    d = { "<Cmd>TroubleToggle document_diagnostics<CR>", "Document Diagnostics" },
    f = { "<Cmd>TroubleToggle lsp_definitions<CR>", "Definitions" },
    l = { "<Cmd>TroubleToggle loclist<CR>", "Location List" },
    q = { "<Cmd>TroubleToggle quickfix<CR>", "Quick Fix" },
    r = { "<Cmd>TroubleToggle lsp_references<CR>", "References" },
    w = { "<Cmd>TroubleToggle workspace_diagnostics<CR>", "Workspace Diagnostics" },
  }

  lvim.builtin.which_key.mappings.l.r = { ":IncRename ", "Rename (new name)" }
  lvim.builtin.which_key.mappings.lR = {
    function() return ":IncRename " .. vim.fn.expand("<cword>") end,
    "Rename (keep name)",
    expr = true,
  }

  -- Treesitter
  lvim.builtin.which_key.mappings.T = {
    name = " Treesitter",
    i = { "<Cmd>TSInstallInfo<CR>", "Info" },
    u = { "<Cmd>TSUpdateSync<CR>", "Update" },
    h = { "<Cmd>TSBufToggle highlight<CR>", "Toggle highlight" },
  }

  if vim.fn.has("nvim-0.10") == 1 then
    lvim.builtin.which_key.mappings.I = { "<Cmd>lua vim.lsp.buf.inlay_hint(0)<CR>", "󰊈 Toggle Inlay Hints" }
  end
end

return M
