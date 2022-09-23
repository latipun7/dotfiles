local M = {}

M.config = function()
  lvim.builtin.global_statusline = true

  lvim.builtin.breadcrumbs.active = true
  lvim.builtin.illuminate.active = true
  lvim.builtin.indentlines.active = true
  lvim.builtin.lir.active = false
  lvim.builtin.notify.active = true
  lvim.builtin.nvimtree.active = false

  -- ▄▖       ▘    ▜   ▗▘▗       ▜   ▗        ▝▖
  -- ▐ █▌▛▘▛▛▌▌▛▌▀▌▐   ▐ ▜▘▛▌▛▌▛▌▐ █▌▜▘█▌▛▘▛▛▌ ▌
  -- ▐ ▙▖▌ ▌▌▌▌▌▌█▌▐▖  ▐ ▐▖▙▌▙▌▙▌▐▖▙▖▐▖▙▖▌ ▌▌▌ ▌
  --                   ▝▖    ▄▌▄▌             ▗▘

  lvim.builtin.terminal.active = true
  lvim.builtin.terminal.open_mapping = "<C-Space>"
  lvim.builtin.terminal.execs = { { "lazygit", "<Leader>gg", " LazyGit" } }

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

  -- ▄▖        ▘▗ ▗
  -- ▐ ▛▘█▌█▌▛▘▌▜▘▜▘█▌▛▘
  -- ▐ ▌ ▙▖▙▖▄▌▌▐▖▐▖▙▖▌

  lvim.builtin.treesitter.auto_install = true
  lvim.builtin.treesitter.highlight.enabled = true
  lvim.builtin.treesitter.matchup.enable = true
  lvim.builtin.treesitter.highlight.additional_vim_regex_highlighting =
    { "yaml" }
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
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["av"] = "@variable.outer",
        ["iv"] = "@variable.inner",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<Leader><M-a>"] = "@parameter.inner",
        ["<Leader><M-f>"] = "@function.outer",
        ["<Leader><M-e>"] = "@element",
      },
      swap_previous = {
        ["<Leader><M-A>"] = "@parameter.inner",
        ["<Leader><M-F>"] = "@function.outer",
        ["<Leader><M-E>"] = "@element",
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

return M
