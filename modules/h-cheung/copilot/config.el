;;; h-cheung/copilot/config.el -*- lexical-binding: t; -*-

(use-package! copilot
  :bind
  (:map copilot-mode-map
   ("C-e" . 'copilot-accept-or-forward)
   ("M-n" . 'copilot-next-completion)
   ("M-p" . 'copilot-previous-completion))
  :config
  (global-copilot-mode 1))

(after! acm
  (map!
   :map acm-mode-map
   "M-n" nil
   "M-p" nil))
