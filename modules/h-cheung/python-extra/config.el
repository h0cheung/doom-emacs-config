;;; h-cheung/python-extra/config.el -*- lexical-binding: t; -*-
(after! lsp-python-ms
  (let ((ppath (string-trim (shell-command-to-string
                             "fd -a ^Microsoft.Python.LanguageServer$ $HOME/.vscode-oss/extensions | tail -1"))))
    (unless (or (string-blank-p ppath) (string-prefix-p "[fd error]:" ppath))
      (setq lsp-python-ms-executable ppath)
      (setq lsp-python-ms-dir
            (file-name-directory lsp-python-ms-executable)))))
