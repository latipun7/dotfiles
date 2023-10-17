return {
  { "camnw/lf-vim" },
  { "elkowar/yuck.vim" },
  { "alker0/chezmoi.vim" },
  {
    "eraserhd/parinfer-rust",
    ft = { "yuck", "lisp", "clojure" },
    enabled = (vim.fn.executable("cargo") == 1),
    build = "cargo build --release",
  },
}
