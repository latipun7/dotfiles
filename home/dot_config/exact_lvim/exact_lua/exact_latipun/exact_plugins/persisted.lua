local M = {}

M.keybindings = function()
  lvim.builtin.which_key.mappings.S = {
    "<Cmd>lua require('telescope').extensions.persisted.persisted()<CR>",
    " pick session to load",
  }
end

M.config = function()
  local title = "Persisted Session"

  require("persisted").setup({
    silent = true,
    use_git_branch = true,
    autosave = true,
    autoload = false,
    allowed_dirs = nil,
    ignored_dirs = nil,
    should_autosave = function()
      -- do not autosave if the alpha dashboard is the current filetype
      if vim.bo.filetype == "alpha" then return false end
      return true
    end,
    after_source = function()
      local status_ok, _ = pcall(require, "notify")
      if status_ok then
        vim.notify("Loaded session", vim.log.levels.INFO, { title = title })
      else
        print("Loaded session")
      end
    end,
    telescope = {
      before_source = function()
        local status_ok, _ = pcall(require, "bufdelete")
        if status_ok then
          vim.api.nvim_input("<Esc><Cmd>bufdo Bdelete<CR>")
        else
          vim.api.nvim_input("<Esc><Cmd>%bd<CR>")
        end
      end,
      after_source = function(session)
        vim.defer_fn(function()
          local status_ok, _ = pcall(require, "notify")
          if status_ok then
            vim.notify(
              "Loaded session " .. session.name,
              vim.log.levels.INFO,
              { title = title }
            )
          else
            print("Loaded session " .. session.name)
          end
        end, 0)
      end,
    },
  })

  require("telescope").load_extension("persisted")
end

return M
