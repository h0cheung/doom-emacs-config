;; -*- no-byte-compile: t; -*-
;;; h-cheung/chinese/packages.el


(package! rime)
(package! ace-pinyin)
(package! pinyinlib)
(when (featurep! :editor evil) (package! evil-pinyin))
