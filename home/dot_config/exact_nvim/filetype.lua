vim.filetype.add({
  extensions = {
    tfstate = "json",
    mdx = "markdown",
  },
  filename = {
    ["rc.lua.test"] = "lua",
    ["dunstrc"] = "confini",
  },
  pattern = { -- regex
    [".*ignore"] = "gitignore",
    [".conf"] = {
      priority = -math.huge,
      function(_, bufnr)
        local content = vim.filetype.getlines(bufnr, 1)
        if content:find("<%?xml") then
          return "xml"
        else
          return "conf"
        end
      end,
    },
  },
})
