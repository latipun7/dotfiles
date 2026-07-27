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
}
