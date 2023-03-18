if vim.fn.expand("%:t") == "Cargo.toml" then
  local lsp_manager = require("lvim.lsp.manager")

  lsp_manager.setup("taplo")

  local whk_status, whk = pcall(require, "which-key")
  if not whk_status or not lvim.builtin.latipun.rust_programming.active then return end

  whk.register({
    C = {
      name = "󰏖 Crates",
      t = { "<Cmd>lua require('crates').toggle()<CR>", "Toggle Crate" },
      r = { "<Cmd>lua require('crates').reload()<CR>", "Reload" },
      u = { "<Cmd>lua require('crates').update_crate()<CR>", "Update Crate" },
      U = { "<Cmd>lua require('crates').upgrade_crate()<CR>", "Upgrade Crate" },
      a = {
        "<Cmd>lua require('crates').update_all_crates()<CR>",
        "Update all crates",
      },
      A = {
        "<Cmd>lua require('crates').upgrade_all_crates()<CR>",
        "Upgrade all crates",
      },
      h = { "<Cmd>lua require('crates').open_homepage()<CR>", "Open Homepage" },
      d = {
        "<Cmd>lua require('crates').open_documentation()<CR>",
        "Open Documentation",
      },
      R = {
        "<Cmd>lua require('crates').open_repository()<CR>",
        "Open Repository",
      },
      v = {
        "<Cmd>lua require('crates').show_versions_popup()<CR>",
        "Show Versions",
      },
      f = {
        "<Cmd>lua require('crates').show_features_popup()<CR>",
        "Show Features",
      },
      D = {
        "<Cmd>lua require('crates').show_dependencies_popup()<CR>",
        "Show Dependencies",
      },
    },
  }, {
    mode = "n",
    prefix = "<leader>",
    silent = true,
    noremap = true,
    nowait = true,
  })
end
