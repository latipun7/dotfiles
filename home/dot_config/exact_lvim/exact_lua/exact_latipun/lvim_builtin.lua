local M = {}
local kind = require("latipun.lsp_kind")

M.config = function()
  local ok, devicons = pcall(require, "nvim-web-devicons")
  if ok then devicons.set_default_icon("", "#6d8086") end

  lvim.builtin.latipun = {
    noice = { active = true },
    barbecue = { active = true },
    inlay_hints = { active = true },
    rust_programming = { active = true },
    tsjs_programming = { active = true },
  }

  lvim.builtin.global_statusline = true

  lvim.builtin.lir.active = false
  lvim.builtin.bigfile.active = true
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

    local status_ok, big_file_detected = pcall(vim.api.nvim_buf_get_var, buf, "bigfile_disable_treesitter")
    return status_ok and big_file_detected
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
    "vimdoc",
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
    "rust",
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

  -- ▄▖▖  ▖▄▖
  -- ▌ ▛▖▞▌▙▌
  -- ▙▖▌▝ ▌▌

  local cmp_border = {
    { "╭", "NoiceCmdlinePopupBorder" },
    { "─", "NoiceCmdlinePopupBorder" },
    { "╮", "NoiceCmdlinePopupBorder" },
    { "│", "NoiceCmdlinePopupBorder" },
    { "╯", "NoiceCmdlinePopupBorder" },
    { "─", "NoiceCmdlinePopupBorder" },
    { "╰", "NoiceCmdlinePopupBorder" },
    { "│", "NoiceCmdlinePopupBorder" },
  }
  local cmp_sources = {
    calc = "(Calc)",
    crates = "(Crates)",
    treesitter = "(TS)",
  }

  lvim.builtin.cmp.window.completion.border = cmp_border
  lvim.builtin.cmp.window.documentation.border = cmp_border
  lvim.builtin.cmp.sources = {
    { name = "nvim_lsp" },
    { name = "buffer", max_item_count = 5, keyword_length = 3 },
    { name = "path", max_item_count = 5 },
    { name = "luasnip", max_item_count = 3 },
    { name = "calc" },
    { name = "treesitter" },
  }
  lvim.builtin.cmp.formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      if entry.source.name == "cmdline" then
        vim_item.kind = "⌘"
        vim_item.menu = ""
        return vim_item
      end
      vim_item.menu = cmp_sources[entry.source.name] or vim_item.kind
      vim_item.kind = kind.cmp_kind[vim_item.kind] or vim_item.kind

      return vim_item
    end,
  }
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

  -- ▖ ▄▖▄▖
  -- ▌ ▚ ▙▌
  -- ▙▖▄▌▌

  if lvim.builtin.latipun.noice.active then
    local status_ok, noice = pcall(require, "noice.lsp.hover")
    if status_ok then vim.lsp.handlers["textDocument/hover"] = noice.on_hover end
  end

  lvim.lsp.buffer_mappings.normal_mode.gA = {
    "<Cmd>lua if vim.bo.filetype == 'rust' then vim.cmd[[RustHoverActions]] else vim.lsp.codelens.run() end<CR>",
    "CodeLens Action",
  }

  lvim.lsp.buffer_mappings.normal_mode.K = {
    "<Cmd>lua require('latipun.lvim_builtin').show_documentation()<CR>",
    "Show Documentation",
  }

  lvim.lsp.on_attach_callback = M.lsp_on_attach_callback
end

M.show_documentation = function()
  local filetype = vim.bo.filetype
  if vim.tbl_contains({ "vim", "help" }, filetype) then
    vim.cmd("h " .. vim.fn.expand("<cword>"))
  elseif vim.tbl_contains({ "man" }, filetype) then
    vim.cmd("Man " .. vim.fn.expand("<cword>"))
  elseif vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
    require("crates").show_popup()
  elseif filetype == "rust" then
    local found, rt = pcall(require, "rust-tools")
    if found then
      rt.hover_actions.hover_actions()
    else
      vim.lsp.buf.hover()
    end
  else
    vim.lsp.buf.hover()
  end
end

M.lsp_on_attach_callback = function(client, _)
  local wkstatus_ok, which_key = pcall(require, "which-key")
  if not wkstatus_ok then return end

  local mappings = {}

  local opts = {
    mode = "n",
    prefix = "<leader>",
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = true,
  }

  if client.name == "rust_analyzer" then
    mappings.H = {
      "<Cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='cargo clippy;read',count=2,direction='float'})<CR>",
      "󱫆 Clippy",
    }
    if lvim.builtin.latipun.rust_programming.active then
      mappings.lA = { "<Cmd>RustHoverActions<CR>", "Hover Actions" }
      mappings.lm = { "<Cmd>RustExpandMacro<CR>", "Expand Macro" }
      mappings.le = { "<Cmd>RustRunnables<CR>", "Runnables" }
      mappings.lD = { "<Cmd>RustDebuggables<CR>", "Debuggables" }
      mappings.lP = { "<Cmd>RustParentModule<CR>", "Parent Module" }
      mappings.lv = { "<Cmd>RustViewCrateGraph<CR>", "View Crate Graph" }
      mappings.lR = {
        "<Cmd>lua require('rust-tools.workspace_refresh')._reload_workspace_from_cargo_toml()<CR>",
        "Reload Workspace",
      }
      mappings.lc = { "<Cmd>RustOpenCargo<CR>", "Open Cargo" }
      mappings.lo = { "<Cmd>RustOpenExternalDocs<CR>", "Open External Docs" }
    end
  end

  which_key.register(mappings, opts)
end

return M
