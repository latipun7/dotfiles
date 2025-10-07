return {
  { "nvim-mini/mini.bufremove", enabled = false },
  {
    "famiu/bufdelete.nvim",
    event = "BufReadPre",
    keys = {
      { "<leader>bd", function() require("bufdelete").bufdelete(0, false) end, desc = "Delete Buffer" },
      { "<leader>bD", function() require("bufdelete").bufdelete(0, true) end, desc = "Delete Buffer (Force)" },
    },
  },
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      opts.options.close_command = function(n) require("bufdelete").bufdelete(n, false) end
      opts.options.right_mouse_command = function(n) require("bufdelete").bufdelete(n, false) end
    end,
  },
}
