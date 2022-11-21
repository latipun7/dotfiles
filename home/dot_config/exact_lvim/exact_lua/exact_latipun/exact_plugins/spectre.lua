local M = {}

M.keybindings = function()
  lvim.builtin.which_key.vmappings.R = {
    "<Esc>:lua require('spectre').open_visual()<CR>",
    "Replace word",
  }

  lvim.builtin.which_key.mappings.R = {
    name = " Replace",
    p = { "<Cmd>lua require('spectre').open()<CR>", "Project" },
    f = {
      "<Cmd>lua require('spectre').open_file_search()<CR>",
      "Current buffer",
    },
    w = {
      "<Cmd>lua require('spectre').open_visual({select_word=true})<CR>",
      "Replace word",
    },
  }
end

M.config = function()
  local status_ok, spectre = pcall(require, "spectre")
  if not status_ok then return end

  local sed_args = nil
  if vim.fn.has("mac") == 1 then sed_args = { "-I", "" } end

  spectre.setup({
    mapping = {
      ["toggle_line"] = {
        map = "t",
        cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
        desc = "toggle current item",
      },
      ["send_to_qf"] = {
        map = "Q",
        cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
        desc = "send all item to quickfix",
      },
      ["replace_cmd"] = {
        map = "c",
        cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
        desc = "input replace vim command",
      },
      ["show_option_menu"] = {
        map = "o",
        cmd = "<cmd>lua require('spectre').show_options()<CR>",
        desc = "show option",
      },
      ["run_replace"] = {
        map = "R",
        cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
        desc = "replace all",
      },
      ["change_view_mode"] = {
        map = "m",
        cmd = "<cmd>lua require('spectre').change_view()<CR>",
        desc = "change result view mode",
      },
      ["toggle_ignore_case"] = {
        map = "I",
        cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
        desc = "toggle ignore case",
      },
      ["toggle_ignore_hidden"] = {
        map = "H",
        cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
        desc = "toggle search hidden",
      },
    },
    replace_engine = {
      ["sed"] = {
        cmd = "sed",
        args = sed_args,
      },
    },
    default = {
      find = {
        cmd = "rg",
        options = { "ignore-case" },
      },
      replace = { cmd = "sed" },
    },
  })
end

return M
