local window_width_limit = 100
local window_large_width = 150

local conditions = {
  not_empty_buffer = function()
    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
  end,

  is_in_width_limit = function()
    return vim.fn.winwidth(0) > window_width_limit
  end,

  is_large_width = function()
    return vim.fn.winwidth(0) > window_large_width
  end,

  is_git_workspace = function()
    local filepath = vim.fn.expand("%:p:h")
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

return conditions
