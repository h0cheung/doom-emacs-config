;;; h-cheung/evil-hybird/config.el -*- lexical-binding: t; -*-

(after! evil
  (defalias 'evil-insert-state 'evil-emacs-state)
  (define-key evil-emacs-state-map (kbd "<escape>")
    'evil-normal-state))
