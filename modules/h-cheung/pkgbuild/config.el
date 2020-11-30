;;; h-cheung/pkgbuild/config.el -*- lexical-binding: t; -*-

(use-package! pkgbuild-mode
  :custom
  (pkgbuild-srcinfo-command "makepkg --printsrcinfo > .SRCINFO"))
