return {
  { "folke/persistence.nvim", enabled = false },
  {
    "olimorris/persisted.nvim",
    event = "BufReadPre",
    opts = {
      use_git_branch = true,
      autostart = true,
      autoload = false,
      should_save = function()
        if vim.bo.filetype == "alpha" then return false end
        if vim.bo.filetype == "" and vim.api.nvim_buf_get_name(0) == "" then return false end
        if vim.api.nvim_buf_get_name(0):match("COMMIT_EDITMSG") then return false end
        return true
      end,
    },
    keys = {
      {
        "<leader>Ss",
        function() require("persisted").select() end,
        desc = "Pick session to load",
      },
      {
        "<leader>St",
        function() require("persisted").toggle() end,
        desc = "Toggle sessions saving",
      },
    },
    init = function()
      local persisted = require("persisted")
      local utils = require("persisted.utils")
      local config = require("persisted.config")

      local function escape_pattern(str, pattern, replace, n)
        pattern = string.gsub(pattern, "[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1") -- escape pattern
        replace = string.gsub(replace, "[%%]", "%%%%") -- escape replacement

        return string.gsub(str, pattern, replace, n)
      end

      local function session_data()
        local sep = utils.dir_pattern()

        local session = persisted.current()
        local session_name = escape_pattern(session, config.save_dir, "")
          :gsub("%%", sep)
          :gsub(vim.fn.expand("~"), sep)
          :gsub("//", "")
          :sub(1, -5)

        if vim.fn.has("win32") == 1 then
          session_name = escape_pattern(session_name, sep, ":", 1)
          session_name = escape_pattern(session_name, sep, "\\")
        end

        local branch, dir_path

        if string.find(session_name, "@@", 1, true) then
          local splits = vim.split(session_name, "@@", { plain = true })
          branch = table.remove(splits, #splits)
          dir_path = vim.fn.join(splits, "@@")
        else
          dir_path = session_name
        end

        return {
          ["name"] = session_name,
          ["file_path"] = session,
          ["branch"] = branch,
          ["dir_path"] = dir_path,
        }
      end

      local function format_display()
        local data = session_data()

        local str
        if data.branch ~= "" then
          str = string.format("%s (branch: %s)", data.dir_path, data.branch)
        else
          str = data.dir_path
        end
        return str
      end

      -- create autocmds
      local create_augroup = vim.api.nvim_create_augroup
      local create_aucmd = vim.api.nvim_create_autocmd

      local title = "Persisted Session"
      local persisted_hooks_group = create_augroup("lazyvim_persisted_hooks", { clear = true })

      create_aucmd("User", {
        pattern = "PersistedLoadPost",
        group = persisted_hooks_group,
        callback = function()
          local str = format_display()
          vim.notify("Loaded session " .. str, vim.log.levels.INFO, { title = title })
        end,
      })

      create_aucmd("User", {
        pattern = { "PersistedTelescopeLoadPre", "PersistedSelectPre" },
        group = persisted_hooks_group,
        callback = function()
          -- Save the currently loaded session passing in the path to the current session
          require("persisted").save({ session = vim.g.persisted_loaded_session })

          -- Delete all of the open buffers
          local status_ok, _ = pcall(require, "bufdelete")
          if status_ok then
            vim.api.nvim_input("<Esc><Cmd>bufdo Bdelete!<CR>")
          else
            vim.api.nvim_input("<Esc><Cmd>%bd!<CR>")
          end
        end,
      })
    end,
  },
}
