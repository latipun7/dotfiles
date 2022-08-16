local M = {}

M.keybindings = function()
  lvim.builtin.which_key.mappings["S"] = {
    "<Cmd>lua require('telescope').extensions.persisted.persisted()<CR>",
    " pick session to load",
  }
end

M.config = function()
  local title = "Persisted Session"

  require("persisted").setup({
    use_git_branch = true,
    autosave = true,
    autoload = false,
    allowed_dirs = nil,
    ignored_dirs = nil,
    after_source = function()
      vim.notify("Loaded session", vim.log.levels.INFO, { title = title })
      print("Loaded session")
    end,
    telescope = {
      before_source = function()
        vim.api.nvim_input("<Esc><Cmd>%bd<CR>")
      end,
      after_source = function(session)
        vim.notify(
          "Loaded session " .. session.name,
          vim.log.levels.INFO,
          { title = title }
        )
      end,
    },
  })

  require("telescope").load_extension("persisted")
end

return M
