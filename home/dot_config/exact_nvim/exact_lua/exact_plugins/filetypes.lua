return {
  { "alker0/chezmoi.vim", enabled = false },
  { "camnw/lf-vim" },
  { "elkowar/yuck.vim" },
  {
    "eraserhd/parinfer-rust",
    ft = { "yuck", "lisp", "clojure" },
    enabled = (vim.fn.executable("cargo") == 1),
    build = "cargo build --release",
  },
  {
    "chomosuke/typst-preview.nvim",
    opts = function()
      local is_windows = vim.fn.has("win32") == 1
      local tinymist_bin = "tinymist"
      local tinymist_path = is_windows and (tinymist_bin .. ".cmd") or tinymist_bin

      return {
        dependencies_bin = {
          ["tinymist"] = tinymist_path,
        },
      }
    end,
  },
}
