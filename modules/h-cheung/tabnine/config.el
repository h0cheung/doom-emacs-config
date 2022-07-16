;;; h-cheung/tabnine/config.el -*- lexical-binding: t; -*-

;; copied and modified from TheEros/doom.d

(use-package! tabnine-capf
  :after cape
  :hook
  (kill-emacs . tabnine-capf-kill-process))

(defvar-local tabnine-buffer-capf nil)

(defun tabnine-enable-buffer(&optional capf-with-tabnine &rest _)
  (interactive)
  (if capf-with-tabnine
      (progn
        (remove-hook 'completion-at-point-functions
                     capf-with-tabnine
                     t)
        (setq-local tabnine-buffer-capf
                    (cape-super-capf
                     #'tabnine-completion-at-point
                     capf-with-tabnine)))
    (setq-local tabnine-buffer-capf
                #'tabnine-completion-at-point))
  (add-hook 'completion-at-point-functions
            tabnine-buffer-capf
            nil t))

(defun tabnine-disable-buffer (&rest _)
  (interactive)
  (when tabnine-buffer-capf
    (remove-hook 'completion-at-point-functions
                 tabnine-buffer-capf t)))

(after! lspce
        (defadvice! start-tabnine-with-lsp(&rest _)
          :before 'lspce--buffer-enable-lsp
          (tabnine-enable-buffer #'lspce-completion-at-point))

        (defadvice! remove-merge-lspce-with-tabnine(&rest _)
          :before 'lspce--buffer-disable-lsp
          (tabnine-disable-buffer)))
                        
           

(after! company
  (defadvice! tabnine-zero-prefix(&rest _)
    :before 'tabnine-enable-buffer
    (setq-local company-minimum-prefix-length 0)))

(after! corfu
  (defadvice! tabnine-zero-prefix(&rest _)
    :before 'tabnine-enable-buffer
    (setq-local corfu-auto-prefix 0)))

(after! kind-icon
  (defadvice! tabnine-kind-icon(&rest _)
    :before 'tabnine-enable-buffer
    (add-to-ordered-list
     'kind-icon-mapping
     '(tabnine "9" :icon "numeric-9" :face font-lock-string-face))))
