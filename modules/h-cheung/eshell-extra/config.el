;;; h-cheung/eshell-extra/config.el -*- lexical-binding: t; -*-
(map!
 (:leader
  (:prefix ("e" . "run-in-eshell")
   :desc "Run custom command"
   "c" #'run-in-eshell
   :desc "Run single code file"
   "r" #'run-code-eshell
   :desc "Run cpp with fsanitize"
   "f" #'run-cpp-fsanitize-eshell)))
