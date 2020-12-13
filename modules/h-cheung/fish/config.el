;;; h-cheung/fish/config.el -*- lexical-binding: t; -*-

(use-package! fish-mode
  :custom
  (fish-enable-auto-indent t)
  :config
  (set-company-backend! 'fish-mode '(company-fish-shell :with company-files)))
