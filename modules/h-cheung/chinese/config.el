;;; h-cheung/chinese/config.el -*- lexical-binding: t; -*-

;; based on cnsunyour's configs

;; (use-package! pangu-spacing
;;   :hook (text-mode . pangu-spacing-mode)
;;   :config
;;   ;; Always insert `real' space in org-mode.
;;   (setq-hook! 'org-mode-hook pangu-spacing-real-insert-separtor t))

(bind-key* "C-\\" #'toggle-input-method)

(use-package! ace-pinyin
  :after avy
  :init (setq ace-pinyin-use-avy t)
  :config (ace-pinyin-global-mode t))

; disable gtk im modules for emacs-pgtk, add "Emacs*UseXIM: false" to ~/.Xresources to disable xim
(when (boundp 'pgtk-use-im-context-on-new-connection)
  (setq pgtk-use-im-context-on-new-connection nil))

;;
;;; Hack
;;;
(define-advice org-html-paragraph (:filter-args (args) chinese-a)
  "Join consecutive Chinese lines into a single long line without
unwanted space when exporting org-mode to html."
  (++chinese--org-paragraph args))

(define-advice org-hugo-paragraph (:filter-args (args) chinese-a)
  "Join consecutive Chinese lines into a single long line without
unwanted space when exporting org-mode to hugo markdown."
  (++chinese--org-paragraph args))

(defun ++chinese--org-paragraph (args)
  (cl-destructuring-bind (paragraph content info) args
    (let* ((origin-contents
            (replace-regexp-in-string
             "<[Bb][Rr][[:blank:]]*/>"
             ""
             content))
           (origin-contents
            (replace-regexp-in-string
             "\\([[:multibyte:]]\\)[[:blank:]]*\n[[:blank:]]*\\([[:multibyte:]]\\)"
             "\\1\\2"
             origin-contents))
           (fixed-contents
            (replace-regexp-in-string
             "\\([^[:blank:]]\\)[[:blank:]]*\n[[:blank:]]*\\([^[:blank:]]\\)"
             "\\1 \\2"
             origin-contents)))
      (list paragraph fixed-contents info))))


(use-package! rime
  :bind
  ("C-S-s-j" . #'+rime-convert-string-at-point)
  (:map rime-active-mode-map
   ("C-S-s-j" . #'rime-inline-ascii)
   ("C-M-S-s-j" . #'rime-inline-ascii))
  (:map rime-mode-map
   ("C-M-S-s-j" . #'rime-force-enable)
   ("C-." . #'rime-send-keybinding)
   ("S-SPC" . #'rime-send-keybinding)
   ("C-`" . #'rime-send-keybinding)
   ("C-~" . #'rime-send-keybinding)
   ("C-S-`" . #'rime-send-keybinding))
  :custom
  (default-input-method "rime")
  (rime-share-data-dir
   (cl-some (lambda (dir)
              (let ((abs-dir (expand-file-name dir)))
                (when (file-directory-p abs-dir)
                  abs-dir)))
            '("/usr/share/rime-data"
              "/usr/share/local"
              "/usr/share")))

  (rime-user-data-dir (expand-file-name "~/.local/share/emacs-rime"))
  (rime-show-candidate 'posframe)
  (rime-show-preedit 'inline)
  (rime-posframe-style 'simple)
  (rime-inline-ascii-trigger 'shift-l)
  :hook
  ((after-init kill-emacs) . (lambda ()
                               (when (fboundp 'rime-lib-sync-user-data)
                                 (ignore-errors (rime-sync)))))
  :config
  (add-hook! (org-mode
              markdown-mode
              beancount-mode)
    (activate-input-method default-input-method))

  (defun +rime-force-enable ()
    "[ENHANCED] Force into Chinese input state.

If current input method is not `rime', active it first. If it is
currently in the `evil' non-editable state, then switch to
`evil-insert-state'."
    (interactive)
    (let ((input-method "rime"))
      (unless (string= current-input-method input-method)
        (activate-input-method input-method))
      (when (rime-predicate-evil-mode-p)
        (if (= (1+ (point)) (line-end-position))
            (evil-append 1)
          (evil-insert 1)))
      (rime-force-enable)))

  (defun +rime-convert-string-at-point ()
    "Convert the string at point to Chinese using the current input scheme.

First call `+rime-force-enable' to active the input method, and
then search back from the current cursor for available string (if
a string is selected, use it) as the input code, call the current
input scheme to convert to Chinese."
    (interactive)
    (+rime-force-enable)
    (let ((string (if mark-active
                      (buffer-substring-no-properties
                       (region-beginning) (region-end))
                    (buffer-substring-no-properties
                     (point) (max (line-beginning-position) (- (point) 80)))))
          code
          length)
      (cond ((string-match "\\([a-z]+\\|[[:punct:]]\\)[[:blank:]]*$" string)
             (setq code (replace-regexp-in-string
                         "^[-']" ""
                         (match-string 0 string)))
             (setq length (length code))
             (setq code (replace-regexp-in-string " +" "" code))
             (if mark-active
                 (delete-region (region-beginning) (region-end))
               (when (> length 0)
                 (delete-char (- 0 length))))
             (when (> length 0)
               (setq unread-command-events
                     (append (listify-key-sequence code)
                             unread-command-events))))
            (t (message "`+rime-convert-string-at-point' did nothing.")))))

  (unless (fboundp 'rime--posframe-display-content)
    (error "Function `rime--posframe-display-content' is not available."))
  (define-advice rime--posframe-display-content (:filter-args (args) resolve-posframe-issue-a)
    "给 `rime--posframe-display-content' 传入的字符串加一个全角空
格，以解决 `posframe' 偶尔吃字的问题。"
    (cl-destructuring-bind (content) args
      (let ((newresult (if (string-blank-p content)
                           content
                         (concat content "　"))))
        (list newresult))))

  (when (featurep! +rime-predicates)
    (load! "+rime-predicates")))

(use-package! pinyinlib
  :commands (pinyinlib-build-regexp-string)
  :init
  (defun orderless-regexp-pinyin (str)
    (setf (car str) (pinyinlib-build-regexp-string (car str)))
    str)
  (advice-add 'orderless-regexp :filter-args #'orderless-regexp-pinyin))
