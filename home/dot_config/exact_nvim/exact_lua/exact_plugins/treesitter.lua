return {
  { "windwp/nvim-ts-autotag", event = "InsertEnter" },
  { "nvim-treesitter/nvim-treesitter-context", event = "LazyFile" },

  -- Add Hyprland parser
  {
    "luckasRanarison/tree-sitter-hypr",
    ft = "hypr",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, _)
        local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
        ---@diagnostic disable-next-line: inject-field
        parser_config.hypr = {
          install_info = {
            url = "https://github.com/luckasRanarison/tree-sitter-hypr",
            files = { "src/parser.c" },
            branch = "master",
          },
          filetype = "hypr",
        }
      end,
    },
  },

  -- Tweak treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "astro",
        "bash",
        "c",
        "cmake",
        -- "comment", -- comments are slowing down TS bigtime, so disable for now
        "cpp",
        "css",
        "diff",
        "devicetree",
        "fish",
        "gitignore",
        "glsl",
        "go",
        "graphql",
        "html",
        "http",
        "hypr", -- hyprland parser from luckasRanarison/tree-sitter-hypr above
        "java",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "meson",
        "ninja",
        "php",
        "python",
        "query",
        "rasi",
        "regex",
        "rust",
        "scss",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
      },
    },
  },
}
