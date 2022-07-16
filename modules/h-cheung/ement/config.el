;;; h-cheung/ement/config.el -*- lexical-binding: t; -*-

(use-package! ement
  :custom
  (ement-save-sessions t)
  (ement-sessions-file (concat doom-cache-dir "ement-session.el")))
