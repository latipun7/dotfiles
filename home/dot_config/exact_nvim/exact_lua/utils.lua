local M = {}

---Escapes special characters before performing string substitution
---@param str string
---@param pattern string
---@param replace string
---@param n? integer
---@return string
---@return integer count
function M.escape_pattern(str, pattern, replace, n)
  pattern = string.gsub(pattern, "[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1") -- escape pattern
  replace = string.gsub(replace, "[%%]", "%%%%") -- escape replacement
  return string.gsub(str, pattern, replace, n)
end

return M
