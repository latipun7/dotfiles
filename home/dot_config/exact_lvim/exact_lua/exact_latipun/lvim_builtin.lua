local M = {}
local Log = require("lvim.core.log")

M.config = function()
  lvim.builtin.global_statusline = true

  lvim.builtin.lir.active = false
  lvim.builtin.nvimtree.active = false

  lvim.builtin.comment.pre_hook = function()
    if vim.bo.filetype == "lf" then return "# %s" end
  end

  -- ▄▖▜   ▌     ▗▘ ▌    ▌ ▌        ▌▝▖
  -- ▌▌▐ ▛▌▛▌▀▌  ▐ ▛▌▀▌▛▘▛▌▛▌▛▌▀▌▛▘▛▌ ▌
  -- ▛▌▐▖▙▌▌▌█▌  ▐ ▙▌█▌▄▌▌▌▙▌▙▌█▌▌ ▙▌ ▌
  --     ▌       ▝▖                  ▗▘

  local alpha_opts = require("latipun.plugins.alpha-dashboard").config()
  lvim.builtin.alpha.mode = "custom"
  lvim.builtin.alpha.custom = { config = alpha_opts }

  -- ▖  ▖▌ ▘  ▌   ▌
  -- ▌▞▖▌▛▌▌▛▘▛▌▄▖▙▘█▌▌▌
  -- ▛ ▝▌▌▌▌▙▖▌▌  ▛▖▙▖▙▌
  --                  ▄▌

  lvim.builtin.which_key.setup.plugins.marks = true
  lvim.builtin.which_key.setup.plugins.registers = true
  lvim.builtin.which_key.setup.plugins.presets.z = true
  lvim.builtin.which_key.setup.icons.group = ""

  -- ▄▖        ▘▗ ▗
  -- ▐ ▛▘█▌█▌▛▘▌▜▘▜▘█▌▛▘
  -- ▐ ▌ ▙▖▙▖▄▌▌▐▖▐▖▙▖▌

  local function disable_highlight(lang, buf)
    if vim.tbl_contains({ "latex" }, lang) then return true end

    local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
    if filetype:find("chezmoi") then return true end

    local max_filesize = 1024 * 1024
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    if ok and stats and stats.size > max_filesize then
      if lvim.builtin.illuminate.active then
        pcall(require("illuminate").pause_buf)
      end

      vim.schedule(function()
        vim.api.nvim_buf_call(buf, function()
          vim.cmd("setlocal noswapfile noundofile")

          if vim.tbl_contains({ "json" }, lang) then
            vim.cmd("NoMatchParen")
            vim.cmd("syntax off")
            vim.cmd("syntax clear")
            vim.cmd("setlocal nocursorline nolist bufhidden=unload")

            vim.api.nvim_create_autocmd({ "BufDelete" }, {
              callback = function()
                vim.cmd("DoMatchParen")
                vim.cmd("syntax on")
              end,
              buffer = buf,
            })
          end
        end)
      end)

      Log:info("File larger than 1MB, turned off treesitter for this buffer")

      return true
    end
  end

  lvim.builtin.treesitter.auto_install = true
  lvim.builtin.treesitter.highlight.enabled = true
  lvim.builtin.treesitter.matchup.enable = true
  lvim.builtin.treesitter.highlight.disable = disable_highlight
  lvim.builtin.treesitter.query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
  }
  lvim.builtin.treesitter.incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-n>",
      node_incremental = "<C-n>",
      scope_incremental = "<C-s>",
      node_decremental = "<C-r>",
    },
  }
  lvim.builtin.treesitter.ensure_installed = {
    "bash",
    "comment",
    "css",
    "gitattributes",
    "gitignore",
    "graphql",
    "help",
    "html",
    "javascript",
    "jsdoc",
    "json",
    "json5",
    "jsonc",
    "lua",
    "markdown",
    "markdown_inline",
    "regex",
    "tsx",
    "typescript",
    "vim",
    "vue",
    "yaml",
  }
  lvim.builtin.treesitter.textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["aA"] = "@attribute.outer",
        ["iA"] = "@attribute.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
        ["ac"] = "@call.outer",
        ["ic"] = "@call.inner",
        ["at"] = "@class.outer",
        ["it"] = "@class.inner",
        ["a/"] = "@comment.outer",
        ["i/"] = "@comment.inner",
        ["ai"] = "@conditional.outer",
        ["ii"] = "@conditional.inner",
        ["aF"] = "@frame.outer",
        ["iF"] = "@frame.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["is"] = "@scopename.inner",
        ["as"] = "@statement.outer",
        ["av"] = "@variable.outer",
        ["iv"] = "@variable.inner",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader><M-a>"] = "@parameter.inner",
        ["<leader><M-f>"] = "@function.outer",
        ["<leader><M-e>"] = "@element",
      },
      swap_previous = {
        ["<leader><M-A>"] = "@parameter.inner",
        ["<leader><M-F>"] = "@function.outer",
        ["<leader><M-E>"] = "@element",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]p"] = "@parameter.inner",
        ["]f"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[p"] = "@parameter.inner",
        ["[f"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  }

  -- ▄▖     ▘    ▗
  -- ▙▌▛▘▛▌ ▌█▌▛▘▜▘
  -- ▌ ▌ ▙▌ ▌▙▖▙▖▐▖
  --       ▙▌

  lvim.builtin.project.detection_methods = { "pattern", "lsp" }
  lvim.builtin.project.show_hidden = true
  lvim.builtin.project.patterns = {
    ".git",
    ".editorconfig",
    ".hg",
    ".bzr",
    ".svn",
    "_darcs",
    "Makefile",
    "package.json",
  }
end

-- ▄▖▖  ▖▄▖
-- ▌ ▛▖▞▌▙▌
-- ▙▖▌▝ ▌▌

lvim.builtin.cmp.cmdline.enable = true
lvim.builtin.cmp.cmdline.options = {
  {
    type = ":",
    sources = { { name = "cmdline" }, { name = "path" } },
  },
  {
    type = { "/", "?" },
    sources = { { name = "buffer" } },
  },
}

return M
