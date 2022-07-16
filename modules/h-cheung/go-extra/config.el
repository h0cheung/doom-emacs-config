;;; h-cheung/go-extra/config.el -*- lexical-binding: t; -*-

;; disable go-build checker for single file
(add-hook 'go-mode-hook
          (lambda ()
            (flycheck-disable-checker 'go-build)))
