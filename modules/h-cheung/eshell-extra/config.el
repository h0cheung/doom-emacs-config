;;; h-cheung/eshell-extra/config.el -*- lexical-binding: t; -*-
(when (featurep! :term eshell)
  (map!
   (:leader
    (:prefix ("e" . "run-in-eshell")
     :desc "Run custom command"
     "c" #'run-in-eshell
     :desc "Run single code file"
     "r" #'run-code-eshell
     :desc "Run cpp with fsanitize"
     "f" #'run-cpp-fsanitize-eshell)))

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
             (message "already exits")
             (select-window (get-buffer-window buffer))
             (+eshell-run-command command buffer))
            (here
             (message "here")
             (+eshell/here command))
            ((message "popup")
             (+eshell/toggle nil command)))))

  (defun run-code-eshell ()
    (interactive)
    (if buffer-file-name
        (let ((filename (file-name-sans-extension
                         (file-name-nondirectory buffer-file-name)))
              (dir (if (doom-project-root) (doom-project-root)
                     (file-name-directory buffer-file-name))))
          (pcase major-mode
            ('c-mode (run-in-eshell (concat "cd " dir " && "
                                            "gcc -O2 -std=c11 "
                                            buffer-file-name
                                            " -o /tmp/c-" filename
                                            " && /tmp/c-" filename)))
            ('c++-mode (run-in-eshell (concat "cd " dir " && "
                                              "g++ -O2 -std=gnu++17 "
                                              buffer-file-name
                                              " -o /tmp/cpp-" filename
                                              " && /tmp/cpp-" filename)))
            ('python-mode (run-in-eshell (concat "cd " dir " && "
                                                 "python " buffer-file-name)))
            (_ (message "not supported"))))

      (message "buffer-file-name is nil")))

  (defun run-cpp-fsanitize-eshell ()
    (interactive)
    (if buffer-file-name
        (let ((filename (file-name-sans-extension (file-name-nondirectory buffer-file-name)))
              (dir (if (doom-project-root) (doom-project-root) (file-name-directory buffer-file-name))))
          (run-in-eshell (concat "cd " dir " && " "clang++ -O2 -std=c++17 -fsanitize=undefined " buffer-file-name " -o /tmp/cpp-" filename " && /tmp/cpp-" filename)))
      (message "buffer-file-name is nil"))))
