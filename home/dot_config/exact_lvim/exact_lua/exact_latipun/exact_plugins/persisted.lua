local M = {}

M.keybindings = function()
  lvim.builtin.which_key.mappings.S = {
    "<Cmd>lua require('telescope').extensions.persisted.persisted()<CR>",
    " Pick session to load",
  }
end

M.config = function()
  require("persisted").setup({
    silent = true,
    use_git_branch = true,
    autosave = true,
    autoload = false,
    allowed_dirs = nil,
    ignored_dirs = nil,
    should_autosave = function()
      if vim.bo.filetype == "alpha" then return false end
      if vim.api.nvim_buf_get_name(0):match("COMMIT_EDITMSG") then return false end

      return true
    end,
  })

  local create_augroup = vim.api.nvim_create_augroup
  local create_aucmd = vim.api.nvim_create_autocmd

  local title = "Persisted Session"
  local persisted_hooks = create_augroup("persisted_hooks", { clear = true })

  create_aucmd("User", {
    pattern = "PersistedLoadPost",
    group = persisted_hooks,
    callback = function(session) vim.notify("Loaded session " .. session.data, vim.log.levels.INFO, { title = title }) end,
  })

  create_aucmd("User", {
    pattern = "PersistedTelescopeLoadPre",
    group = persisted_hooks,
    callback = function()
      local status_ok, _ = pcall(require, "bufdelete")
      if status_ok then
        vim.api.nvim_input("<Esc><Cmd>bufdo Bdelete<CR>")
      else
        vim.api.nvim_input("<Esc><Cmd>%bd<CR>")
      end
    end,
  })

  require("telescope").load_extension("persisted")
end

return M
