local M = {}

M.config = function()
  local status_ok, presence = pcall(require, "presence")
  if not status_ok then
    return
  end

  presence:setup({
    auto_update = true,
    neovim_image_text = "LunarVim to the moon",
    main_image = "file",
    enable_line_number = false,
    editing_text = "📝 Editing %s",
    file_explorer_text = "🔎 Browsing %s",
    git_commit_text = "🧑‍💻 Committing changes",
    plugin_manager_text = "🧩 Managing plugins",
    reading_text = "📖 Reading %s",
    workspace_text = "🧠 Working on %s",
    line_number_text = "💾 Line %s out of %s",
  })
end

return M
