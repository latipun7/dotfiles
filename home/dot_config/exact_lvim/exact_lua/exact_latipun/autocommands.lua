local M = {}

local create_augroup = vim.api.nvim_create_augroup
local create_aucmd = vim.api.nvim_create_autocmd

M.config = function()
  -- clear unused autocommands from LunarVim
  vim.api.nvim_clear_autocmds({ pattern = "lir", group = "_filetype_settings" })

  create_aucmd("TermOpen", {
    pattern = "term://*",
    command = "lua require('latipun.keybindings').set_terminal_keymaps()",
  })

  create_aucmd({ "BufWinEnter", "BufRead", "BufNewFile" }, {
    pattern = "*",
    callback = function() vim.cmd("setlocal formatoptions-=c formatoptions-=r formatoptions-=o") end,
  })

  -- needs bufdelete.nvim, neo-tree & alpha-dashboard
  local alpha_on_empty = create_augroup("alpha_on_empty", { clear = true })
  create_aucmd("User", {
    pattern = "BDeletePost*",
    group = alpha_on_empty,
    callback = function(event)
      local fallback_name = vim.api.nvim_buf_get_name(event.buf)
      local fallback_ft = vim.api.nvim_buf_get_option(event.buf, "filetype")
      local fallback_on_empty = fallback_name == "" and fallback_ft == ""

      if fallback_on_empty then
        vim.cmd("Neotree close")
        vim.cmd("Alpha")
        vim.cmd(event.buf .. "bwipeout")
      end
    end,
  })

  -- needs alpha
  -- hide tab line when showing dashboard
  local dashboard_setting = create_augroup("dashboard_setting", {})
  create_aucmd("User", {
    pattern = "AlphaReady",
    group = dashboard_setting,
    command = "set showtabline=0 | autocmd BufUnload <buffer> set showtabline=" .. vim.opt.showtabline._value,
  })

  create_aucmd("BufRead", {
    group = create_augroup("CmpSourceCargo", { clear = true }),
    pattern = "Cargo.toml",
    callback = function()
      require("cmp").setup.buffer({
        sources = {
          { name = "buffer", max_item_count = 5, keyword_length = 3 },
          { name = "crates" },
        },
      })
    end,
  })
end

return M
