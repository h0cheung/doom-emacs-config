;;; h-cheung/ui/config.el -*- lexical-binding: t; -*-

;; based on cnsunyour's config

;; 字体
(setq
 doom-font (font-spec :family "Sarasa Mono SC" :size 18 :weight 'Regular)
 doom-unicode-font (font-spec :family "Sarasa Mono SC" :size 18 :weight 'Regular)
 doom-variable-pitch-font (font-spec :family "Sarasa Mono SC" :size 18 :weight 'Regular)
 doom-big-font (font-spec :family "Sarasa Mono SC" :size 24 :weight 'Regular))

;; emoji 字体 Noto Color Emoji
(defun +font-set-emoji (&rest _)
  (set-fontset-font t 'emoji "Noto Color Emoji" nil 'prepend))

(add-hook! 'after-setting-font-hook #'+font-set-emoji)

;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one-light)

;; 设定popup的窗口形式为右侧开启，宽度为40%
;; (set-popup-rule! "^\\*" :side 'right :size 0.5 :select t)

;; 80列太窄，120列太宽，看着都不舒服，100列正合适
;; (setq-default fill-column 100)

;; 虚拟换行设置
;; (setq-default visual-fill-column-width 120)
;; (global-visual-fill-column-mode 1)
;; (global-visual-line-mode 1)

;; To fix the issue: Unable to load color "brightblack"
(after! hl-fill-column
  (set-face-background 'hl-fill-column-face "#555555"))

(after! doom-modeline
  (setq doom-modeline-icon t
        doom-modeline-major-mode-color-icon t
        doom-modeline-buffer-state-icon t
        doom-modeline-buffer-modification-icon t
        doom-modeline-enable-word-count t
        doom-modeline-indent-info t))
  ;; (when (and (display-graphic-p) (not (daemonp)))
  ;;   (setq doom-modeline-major-mode-icon t)))

(after! lsp-ui
  (setq lsp-ui-doc-position 'at-point
        lsp-ui-flycheck-enable t
        lsp-ui-sideline-ignore-duplicate t
        lsp-ui-sideline-update-mode 'point
        lsp-enable-file-watchers nil
        lsp-ui-doc-enable t))
  ;; (if (featurep 'xwidget-internal)
  ;;     (setq lsp-ui-doc-use-webkit t)))

;; 拆分窗口时默认把焦点定在新窗口，doom为了和vim保持一致，竟然把这点改回去了
(setq evil-split-window-below t
      evil-vsplit-window-right t)

;; 显示时间
(display-time-mode 1)

;; 显示菜单栏和工具栏
(tool-bar-mode 1)
(menu-bar-mode 1)

;; 使用相对行号
(setq display-line-numbers-type 'relative)

;; 为所有文件显示行号
(add-hook 'find-file-hook 'display-line-numbers-mode)


;; disable display line numbers on text-mode
;; (remove-hook 'text-mode-hook #'display-line-numbers-mode)

;; 调整启动时窗口大小/最大化/全屏
;; (pushnew! initial-frame-alist '(width . 200) '(height . 48))
;; (add-hook 'window-setup-hook #'toggle-frame-maximized t)
;; (add-hook 'window-setup-hook #'toggle-frame-fullscreen t)


(use-package! awesome-tab
  :commands (awesome-tab-mode)
  :init
  (defhydra hydra-tab (:pre (awesome-tab-mode t)
                       :post (awesome-tab-mode -1))
    "
   ^^^^Fast Move             ^^^^Tab                    ^^Search            ^^Misc
  -^^^^--------------------+-^^^^---------------------+-^^----------------+-^^---------------------------
     ^_k_^   prev group    | _C-a_^^     select first | _b_ switch buffer | _C-k_   kill buffer
   _h_   _l_ switch tab    | _C-e_^^     select last  | _g_ switch group  | _C-S-k_ kill others in group
     ^_j_^   next group    | _a_^^       ace jump     | ^^                | ^^
   ^^0 ~ 9^^ select window | _C-h_/_C-l_ move current | ^^                | ^^
  -^^^^--------------------+-^^^^---------------------+-^^----------------+-^^---------------------------
  "
    ("h" awesome-tab-backward-tab)
    ("j" awesome-tab-forward-group)
    ("k" awesome-tab-backward-group)
    ("l" awesome-tab-forward-tab)
    ("a" awesome-tab-ace-jump)
    ("C-a" awesome-tab-select-beg-tab)
    ("C-e" awesome-tab-select-end-tab)
    ("C-h" awesome-tab-move-current-tab-to-left)
    ("C-l" awesome-tab-move-current-tab-to-right)
    ("b" ivy-switch-buffer)
    ("g" awesome-tab-counsel-switch-group)
    ("C-k" kill-current-buffer)
    ("C-S-k" awesome-tab-kill-other-buffers-in-current-group)
    ("q" nil "quit"))
  :bind
  (("s-t" . hydra-tab/body)))


;; enable emacs27+ build-in fill-column
(when (>= emacs-major-version 27)
  (add-hook! (text-mode prog-mode conf-mode)
             #'display-fill-column-indicator-mode))
