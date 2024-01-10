local function format_display(session_data)
  local str
  if session_data.branch ~= "" then
    str = string.format("%s (branch: %s)", session_data.dir_path, session_data.branch)
  else
    str = session_data.dir_path
  end
  return str
end

return {
  { "folke/persistence.nvim", enabled = false },
  {
    "olimorris/persisted.nvim",
    event = "BufReadPre",
    opts = {
      silent = true,
      use_git_branch = true,
      autosave = true,
      autoload = false,
      allowed_dirs = nil,
      ignored_dirs = nil,
      should_autosave = function()
        if vim.bo.filetype == "alpha" then return false end
        if vim.bo.filetype == "" and vim.api.nvim_buf_get_name(0) == "" then return false end
        if vim.api.nvim_buf_get_name(0):match("COMMIT_EDITMSG") then return false end
        return true
      end,
    },
    keys = {
      {
        "<leader>Ss",
        function() require("telescope").extensions.persisted.persisted() end,
        desc = "  Pick session to load",
      },
      {
        "<leader>St",
        function() require("persisted").toggle() end,
        desc = "  Toggle sessions saving",
      },
    },
    init = function()
      local create_augroup = vim.api.nvim_create_augroup
      local create_aucmd = vim.api.nvim_create_autocmd

      local title = "Persisted Session"
      local persisted_hooks_group = create_augroup("lazyvim_persisted_hooks", { clear = true })

      create_aucmd("User", {
        pattern = "PersistedLoadPost",
        group = persisted_hooks_group,
        callback = function(session)
          local str = format_display(session.data)
          vim.notify("Loaded session " .. str, vim.log.levels.INFO, { title = title })
        end,
      })

      create_aucmd("User", {
        pattern = "PersistedTelescopeLoadPre",
        group = persisted_hooks_group,
        callback = function(session)
          local path = session.data.dir_path
          if string.find(path, "/") ~= 1 then
            vim.cmd("cd " .. vim.fn.expand("~") .. "/" .. path)
            vim.cmd("tcd " .. vim.fn.expand("~") .. "/" .. path)
          else
            vim.cmd("cd " .. path)
            vim.cmd("tcd " .. path)
          end

          local status_ok, _ = pcall(require, "bufdelete")
          if status_ok then
            vim.api.nvim_input("<Esc><Cmd>bufdo Bdelete<CR>")
          else
            vim.api.nvim_input("<Esc><Cmd>%bd<CR>")
          end
        end,
      })
    end,
  },
}
