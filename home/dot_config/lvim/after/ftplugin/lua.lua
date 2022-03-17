local util = require("lspconfig.util")

local status_ok, lua_dev = pcall(require, "lua-dev")
if not status_ok then
  vim.cmd([[ packadd lua-dev.nvim ]])
  lua_dev = require("lua-dev")
end

local file_name = vim.fn.expand("%:p")

local lspconfig_opts = {
  on_attach = require("lvim.lsp").common_on_attach,
  on_init = require("lvim.lsp").common_on_init,
  capabilities = require("lvim.lsp").common_capabilities(),
  root_dir = util.root_pattern("dot_stylua.toml", ".stylua.toml"),
  settings = {
    Lua = {
      runtime = {
        version = "Lua 5.4",
        path = {
          "?.lua",
          "?/init.lua",
          "/usr/share/awesome/lib/?.lua",
          "/usr/share/awesome/lib/?/init.lua",
          "/usr/share/awesome/themes/?/?.lua",
          "/usr/share/lua/5.4/?.lua",
          "/usr/share/lua/5.4/?/init.lua",
        },
      },
      completion = { callSnippet = "Replace" },
      diagnostics = {
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
        disable = { "lowercase-global" },
      },
      workspace = {
        library = {
          "/usr/share/awesome/lib",
          "/usr/share/awesome/themes",
          "/usr/share/lua/5.4",
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
}

local luadev = lua_dev.setup({
  library = {
    vimruntime = true,
    types = true,
    plugins = true,
  },
  lspconfig = {
    on_attach = require("lvim.lsp").common_on_attach,
    on_init = require("lvim.lsp").common_on_init,
    capabilities = require("lvim.lsp").common_capabilities(),
    root_dir = util.root_pattern("dot_stylua.toml", ".stylua.toml"),
    settings = {
      Lua = {
        diagnostics = {
          disable = { "lowercase-global" },
        },
        workspace = {
          library = {
            [require("lvim.utils").join_paths(get_runtime_dir(), "lvim", "lua")] = true,
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
          },
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
      },
    },
  },
})

local servers = require("nvim-lsp-installer.servers")
local lsp_manager = require("lvim.lsp.manager")
local server_available, requested_server = servers.get_server("sumneko_lua")
local formatters = require("lvim.lsp.null-ls.formatters")
local server_opts

if server_available then
  luadev.cmd_env = requested_server:get_default_options().cmd_env
  lspconfig_opts.cmd_env = requested_server:get_default_options().cmd_env
end

formatters.setup({ { exe = "stylua", filetypes = { "lua" } } })

local config_dir = get_config_dir()
local current_dir = string.sub(file_name, 1, string.len(config_dir))
local dot_dir = os.getenv("XDG_DATA_HOME") .. "/chezmoi/home/dot_config/lvim"

if current_dir == config_dir or current_dir == dot_dir then
  server_opts = luadev
else
  server_opts = lspconfig_opts
end

lsp_manager.setup("sumneko_lua", server_opts)
