local M = {}

M.keybindings = function()
  require("telescope").load_extension("neoclip")

  lvim.builtin.which_key.mappings.y = {
    "<Cmd>Telescope neoclip<CR>",
    "󰅏 Open yank history",
  }

  lvim.builtin.which_key.mappings.m = {
    "<Cmd>Telescope macroscope<CR>",
    "󰚩 Open macro history",
  }
end

M.config = function()
  local status_ok, neoclip = pcall(require, "neoclip")
  if not status_ok then return end

  neoclip.setup({
    history = 50,
    enable_persistent_history = false,
    keys = {
      telescope = {
        i = { select = "<C-p>", paste = "<CR>", paste_behind = "<C-k>" },
        n = { select = "p", paste = "<CR>", paste_behind = "P" },
      },
    },
  })
end

return M
