;; -*- no-byte-compile: t; -*-
;;; h-cheung/copilot/packages.el

(package! copilot
  :recipe (:host github
           :repo "zerolfx/copilot.el"
           :files ("dist" "*.el")))
