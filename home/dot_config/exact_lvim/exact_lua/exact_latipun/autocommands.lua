local M = {}

local create_augroup = vim.api.nvim_create_augroup
local create_aucmd = vim.api.nvim_create_autocmd

local function get_listed_buffers()
  local buffers = {}
  local len = 0
  for buffer = 1, vim.fn.bufnr("$") do
    if vim.fn.buflisted(buffer) == 1 then
      len = len + 1
      buffers[len] = buffer
    end
  end

  return buffers
end

M.config = function()
  create_aucmd("TermOpen", {
    pattern = "term://*",
    command = "lua require('latipun.keybindings').set_terminal_keymaps()",
  })

  -- need bufdelete.nvim & alpha-dashboard
  create_augroup("alpha_on_empty", { clear = true })
  create_aucmd("User", {
    pattern = "BDeletePre",
    group = "alpha_on_empty",
    callback = function(event)
      local found_non_empty_buffer = false
      local buffers = get_listed_buffers()

      for _, bufnr in ipairs(buffers) do
        if not found_non_empty_buffer then
          local name = vim.api.nvim_buf_get_name(bufnr)
          local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")

          if bufnr ~= event.buf and name ~= "" and ft ~= "Alpha" then
            found_non_empty_buffer = true
          end
        end
      end

      if not found_non_empty_buffer then
        vim.cmd("Alpha")
      end
    end,
  })
end

return M
