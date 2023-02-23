if vim.fn.expand("%:t") == "package.json" then
  local whk_status, whk = pcall(require, "which-key")
  if not whk_status or not lvim.builtin.latipun.tsjs_programming.active then
    return
  end

  whk.register({
    n = {
      name = "󰏖 npm",
      s = { "<Cmd>lua require('package-info').show()<CR>", "Show pkg info" },
      c = { "<Cmd>lua require('package-info').hide()<CR>", "Hide pkg info" },
      u = {
        "<Cmd>lua require('package-info').update()<CR>",
        "Update dependency",
      },
      d = {
        "<Cmd>lua require('package-info').delete()<CR>",
        "Delete dependency",
      },
      i = {
        "<Cmd>lua require('package-info').install()<CR>",
        "Install dependency",
      },
      C = {
        "<Cmd>lua require('package-info').change_version()<CR>",
        "Change Version",
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
