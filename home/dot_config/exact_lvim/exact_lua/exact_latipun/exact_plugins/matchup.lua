local M = {}

M.config = function()
  vim.g.matchup_enabled = 1
  vim.g.matchup_surround_enabled = 1
  vim.g.matchup_matchparen_enabled = 1
  vim.g.matchup_matchparen_deferred = 1
  vim.g.matchup_matchparen_offscreen =
    { method = "popup", syntax_hl = 1, border = 1 }
end

return M
