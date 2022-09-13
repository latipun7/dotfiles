local M = {}

M.keybindings = function()
  lvim.builtin.which_key.mappings.y = {
    "<Cmd>lua require('telescope').extensions.neoclip.default()<CR>",
    " Open yank history",
  }

  lvim.builtin.which_key.mappings.m = {
    "<Cmd>lua require('telescope').extensions.macroscope.default()<CR>",
    "ﮧ Open macro history",
  }
end

M.config = function()
  local status_ok, neoclip = pcall(require, "neoclip")
  if not status_ok then
    return
  end

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
