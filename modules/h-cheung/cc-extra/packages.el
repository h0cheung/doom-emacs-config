;; -*- no-byte-compile: t; -*-
;;; h-cheung/google-c-style/packages.el

(package! google-c-style
  :recipe (:host github :repo "google/styleguide"
           :files ("google-c-style.el")
           :branch "gh-pages"))
;; (package! ccls :disable t)
