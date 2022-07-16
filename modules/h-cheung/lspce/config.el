;;; h-cheung/lspce/config.el -*- lexical-binding: t; -*-

(use-package! lspce
  :config
  (setq lspce-send-changes-idle-time 1)
  (defadvice! lspce--root-uri-always-allow-single (&rest _)
    :around 'lspce--root-uri
   (let ((proj (project-current))
         root-uri)
     (setq root-uri
           (if proj
               (project-root proj)
            buffer-file-name))
     (when root-uri
       (lspce--path-to-uri root-uri))))
  ;; log file
  (lspce-disable-logging)
  (defun lsp! (&rest _)
    (interactive)
    (lspce-mode 1))
  (add-hook! 'go-mode-hook #'lsp!)
  (map! :map doom-leader-code-map
        :desc "LSP Rename"
        "r"             #'lspce-rename
        :desc "LSP Code actions"
        "a"             #'lspce-code-actions))
