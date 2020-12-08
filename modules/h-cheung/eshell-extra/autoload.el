;;; h-cheung/eshell-extra/autoload.el -*- lexical-binding: t; -*-

;;;###autoload
(defun run-in-eshell (command &optional here)
  (interactive
   (list
    (let* ((f (cond (buffer-file-name)
                    ((eq major-mode 'dired-mode)
                     (dired-get-filename nil t))))
           (filename (if f
                         (concat " " (shell-quote-argument f))
                       "")))
      (read-shell-command "Terminal command: "
                          (cons filename 0)
                          (cons 'shell-command-history 1)
                          (list filename)))))
  (let ((buffer (+eshell-last-buffer t)))
    (cond (buffer
           (select-window (get-buffer-window buffer))
           (+eshell-run-command command buffer))
          (here
           (+eshell/here command))
          (t
           (+eshell/toggle nil command)))))

;;;###autoload
(defun run-code-eshell ()
  (interactive)
  (if buffer-file-name
      (let ((file-name (shell-quote-argument
                        (file-name-sans-extension
                         (file-name-nondirectory buffer-file-name))))
            (file-path (shell-quote-argument buffer-file-name))
            (dir (if (doom-project-root) (doom-project-root)
                   (file-name-directory buffer-file-name))))
        (pcase major-mode
          ('c-mode (run-in-eshell (concat "cd " dir " && "
                                          "gcc -O2 -std=c11 "
                                          file-path
                                          " -o /tmp/c-" file-name
                                          " && /tmp/c-" file-name)))
          ('c++-mode (run-in-eshell (concat "cd " dir " && "
                                            "g++ -O2 -std=gnu++17 "
                                            file-path
                                            " -o /tmp/cpp-" file-name
                                            " && /tmp/cpp-" file-name)))
          ('python-mode (run-in-eshell (concat "cd " dir " && "
                                               "python " file-path)))
          (_ (message "not supported"))))

    (message "buffer-file-name is nil")))

;;;###autoload
(defun run-cpp-fsanitize-eshell ()
  (interactive)
  (if buffer-file-name
      (let ((file-name (shell-quote-argument
                        (file-name-sans-extension
                         (file-name-nondirectory buffer-file-name))))
            (file-path (shell-quote-argument buffer-file-name))
            (dir (if (doom-project-root) (doom-project-root)
                   (file-name-directory buffer-file-name))))
        (run-in-eshell (concat "cd " dir " && " "clang++ -O2 -std=c++17 -fsanitize=undefined " file-path " -o /tmp/cpp-" file-name " && /tmp/cpp-" file-name)))
    (message "buffer-file-name is nil")))
