local M = {}

M.config = function()
  lvim.builtin.global_statusline = true

  lvim.builtin.lir.active = false
  lvim.builtin.nvimtree.active = false

  -- ▄▖       ▘    ▜   ▗▘▗       ▜   ▗        ▝▖
  -- ▐ █▌▛▘▛▛▌▌▛▌▀▌▐   ▐ ▜▘▛▌▛▌▛▌▐ █▌▜▘█▌▛▘▛▛▌ ▌
  -- ▐ ▙▖▌ ▌▌▌▌▌▌█▌▐▖  ▐ ▐▖▙▌▙▌▙▌▐▖▙▖▐▖▙▖▌ ▌▌▌ ▌
  --                   ▝▖    ▄▌▄▌             ▗▘

  lvim.builtin.terminal.open_mapping = [[<C-\>]]
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

  -- ▖ ▖  ▗ ▘▐▘
  -- ▛▖▌▛▌▜▘▌▜▘▌▌
  -- ▌▝▌▙▌▐▖▌▐ ▙▌
  --           ▄▌

  lvim.builtin.notify.opts.min_width =
    function() return math.floor(vim.o.columns * 0.4) end
  lvim.builtin.notify.opts.max_width =
    function() return math.floor(vim.o.columns * 0.4) end
  lvim.builtin.notify.opts.max_height =
    function() return math.floor(vim.o.lines * 0.8) end
  lvim.builtin.notify.opts.render = function(...)
    local notif = select(2, ...)
    local style = notif.title[1] == "" and "minimal" or "default"
    require("notify.render")[style](...)
  end
  lvim.builtin.notify.opts.stages = "fade_in_slide_out"
  lvim.builtin.notify.opts.timeout = 3000
  lvim.builtin.notify.opts.background_colour = "NormalFloat"
end

-- ▄▖▖  ▖▄▖
-- ▌ ▛▖▞▌▙▌
-- ▙▖▌▝ ▌▌

M.setup_cmdline = function()
  local found, cmp = pcall(require, "cmp")
  if found then
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline({}),
      sources = {
        { name = "cmdline" },
        { name = "path" },
      },
    })
  end
end

return M