return {
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      filetypes = {
        "*",
        css = { css = true },
        scss = { css = true },
        sass = { css = true, sass = { enable = true } },
        javascript = { tailwind = true },
        typescript = { tailwind = true },
        javascriptreact = { tailwind = true },
        typescriptreact = { tailwind = true },
      },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = false,
        RRGGBBAA = true,
        AARRGGBB = true,
        rgb_fn = true,
        hsl_fn = true,
        css = false,
        css_fn = true,
        mode = "background",
      },
      buftypes = {
        "*",
        -- exclude prompt and popup buftypes from highlight
        "!prompt",
        "!popup",
      },
    },
  },
}
