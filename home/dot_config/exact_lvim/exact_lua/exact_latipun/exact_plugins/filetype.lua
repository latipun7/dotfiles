local M = {}

local function getlines(i, j)
  return table.concat(vim.api.nvim_buf_get_lines(0, i - 1, j or i, true), "\n")
end

M.config = function()
  require("filetype").setup({
    overrides = {
      literal = {
        ["dot_editorconfig"] = "dosini",
        [".gitignore"] = "conf",
      },

      extensions = {
        tf = "terraform",
        tfvars = "terraform",
        hcl = "hcl",
        tfstate = "json",
        eslintrc = "json",
        prettierrc = "json",
        mdx = "markdown",
      },

      complex = { -- regex
        [".*ignore"] = "conf",
      },

      function_extensions = {
        ["conf"] = function()
          if getlines(1):find("<%?xml") then
            return "xml"
          else
            return "conf"
          end
        end,
      },
    },
  })
end

return M
