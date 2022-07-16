;; -*- no-byte-compile: t; -*-
;;; h-cheung/lspce/packages.el

(package! lspce
  :recipe (:host github
           :repo "zbelial/lspce"
           :files ("*.so" "*.el")
           :pre-build
           (shell-command "cargo build --release && mv target/release/liblspce_module.so lspce-module.so")))

(package! f)
(package! cape)

(package! lsp-mode :disable t :ignore t)
