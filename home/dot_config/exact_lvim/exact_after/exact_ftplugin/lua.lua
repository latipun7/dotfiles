local util = require("lspconfig.util")

local file_name = vim.fn.expand("%:p")
local lvim_config = get_config_dir() or vim.env.XDG_CONFIG_HOME .. "/lvim"
local current_lvim_config = string.sub(file_name, 1, string.len(lvim_config))
local lvim_dot = vim.env.XDG_DATA_HOME .. "/chezmoi/home/dot_config/exact_lvim"
local current_lvim_dot = string.sub(file_name, 1, string.len(lvim_dot))

local neodev_ok, neodev = pcall(require, "neodev")
if neodev_ok then
  local neodev_util = require("neodev.util")

  neodev.setup({
    override = function(root_dir, library)
      if neodev_util.has_file(root_dir, lvim_dot) then library.enabled = true end
    end,
  })
end

local default_opts = {
  root_dir = util.root_pattern("symlink_dot_stylua.toml.tmpl", ".stylua.toml"),
  settings = {
    Lua = {
      runtime = {
        version = "Lua 5.4",
        path = {
          "?.lua",
          "?/init.lua",
          "/usr/share/awesome/lib/?.lua",
          "/usr/share/awesome/lib/?/init.lua",
          "/usr/share/awesome/themes/?/theme.lua",
          "/usr/share/lua/5.4/?.lua",
          "/usr/share/lua/5.4/?/init.lua",
        },
      },
      completion = { callSnippet = "Both" },
      diagnostics = {
        unusedLocalExclude = { "_*", "test_*" },
        globals = {
          "awesome",
          "mouse",
          "mousegrabber",
          "screen",
          "client",
          "drawable",
          "root",
          "tag",
          "menubar",
          "dbus",
          "selection",
          "signals",
          "xproperties",
        },
      },
      workspace = {
        preloadFileSize = 10000,
        library = {
          "/usr/share/awesome/lib",
          "/usr/share/awesome/themes",
          "/usr/share/lua/5.4",
          "${3rd}/busted/library",
          "${3rd}/luassert/library",
          "${3rd}/luv/library",
          vim.fn.expand("$XDG_DATA_HOME/lua-definitions"),
        },
      },
    },
  },
}

if current_lvim_config == lvim_config or current_lvim_dot == lvim_dot then
  default_opts.settings.Lua.runtime.version = "LuaJIT"
  default_opts.settings.Lua.runtime.path = { "?.lua", "?/init.lua" }
  default_opts.settings.Lua.runtime.special = { reload = "require" }
  default_opts.settings.Lua.diagnostics.globals = { "vim", "lvim", "reload" }
  default_opts.settings.Lua.workspace.library = {
    vim.fn.expand("$VIMRUNTIME"),
    get_lvim_base_dir(),
    "${3rd}/busted/library",
    "${3rd}/luassert/library",
    "${3rd}/luv/library",
  }
end

local lsp_manager = require("lvim.lsp.manager")
local formatters = require("lvim.lsp.null-ls.formatters")

formatters.setup({ { name = "stylua" } })
lsp_manager.setup("lua_ls", default_opts)
