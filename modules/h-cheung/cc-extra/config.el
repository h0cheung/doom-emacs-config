;;; h-cheung/google-c-style/config.el -*- lexical-binding: t; -*-

(set-formatter! 'clang-format
  '("clang-format"
    ("-assume-filename=%s" (or buffer-file-name mode-result ""))
    ("-style=Google"))
  :modes '((c-mode ".c")
           (c++-mode ".cpp")
           (java-mode ".java")
           (objc-mode ".m")
           (protobuf-mode ".proto")))

(set-file-template! "\\(acm\\|codeforces\\|oj\\|training\\).*\\.\\(cpp\\|cc\\|cxx\\)$" :trigger "acm")

(setq-hook! 'c-mode-common-hook
  tab-width 2
  fill-column 80)

(use-package! google-c-style
  :config
  :hook (c-mode-common . google-set-c-style)
  :hook (c-mode-common . google-make-newline-indent))

;; (after! lsp-clients
;;   (set-lsp-priority! 'clangd 1))

(after! c++-mode
  (map!
   :map (c++-mode-map)
   (:leader
    (:prefix ("d" . "debug")
     :desc "Run cpp in gdb"
     :n "c" #'cpp-gdb)))

  (defun cpp-gdb ()
    (interactive)
    (if buffer-file-name
        (let ((filename (file-name-sans-extension (file-name-nondirectory buffer-file-name))))
          (when (eq 0 (shell-command (concat "g++ -O2 -g -std=c++17 " buffer-file-name " -o /tmp/cpp-" filename)))
            (gdb (concat "gdb -i=mi /tmp/cpp-" filename))))
      (message "buffer-file-name is nil"))))

(after! ccls
  (ccls-use-default-rainbow-sem-highlight))

(after! lsp-clangd
  (set-lsp-priority! 'clangd 1))
