;;; h-cheung/vterm-run/config.el -*- lexical-binding: t; -*-
(when (featurep! :term vterm)
  (map!
   (:leader
    (:prefix ("r" . "run-in-vterm")
     :desc "Run custom command"
     "c" #'run-in-vterm
     :desc "Run single code file"
     "r" #'run-code
     :desc "Run cpp with fsanitize"
     "f" #'run-cpp-fsanitize)))

  (defun run-in-vterm-kill (process _event)
    "A process sentinel. Kills PROCESS's buffer if it is live."
    (let ((b (process-buffer process)))
      (and (buffer-live-p b)
           (kill-buffer b))))

  (defun run-in-vterm (command)
    "Execute string COMMAND in a new vterm.
     Interactively, prompt for COMMAND with the current buffer's file
     name supplied. When called from Dired, supply the name of the
     file at point.

     Like `async-shell-command`, but run in a vterm for full terminal features.

     The new vterm buffer is named in the form `*foo bar.baz*`, the
     command and its arguments in earmuffs.

     When the command terminates, the shell remains open, but when the
     shell exits, the buffer is killed."
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
    (+vterm/toggle nil)
    (vterm-send-string command)
    (vterm-send-return))

  (defun run-code ()
    (interactive)
    (if buffer-file-name
        (let ((filename (file-name-sans-extension
                         (file-name-nondirectory buffer-file-name)))
              (dir (if (doom-project-root) (doom-project-root)
                     (file-name-directory buffer-file-name))))
          (pcase major-mode
            ('c-mode (run-in-vterm (concat "cd " dir " && "
                                              "gcc -O2 -std=c11 "
                                              buffer-file-name
                                              " -o /tmp/c-" filename
                                              " && /tmp/c-" filename)))
            ('c++-mode (run-in-vterm (concat "cd " dir " && "
                                              "g++ -O2 -std=gnu++17 "
                                              buffer-file-name
                                              " -o /tmp/cpp-" filename
                                              " && /tmp/cpp-" filename)))
            ('python-mode (run-in-vterm (concat "cd " dir " && "
                                                 "python " buffer-file-name)))
            (_ (message "not supported"))))

      (message "buffer-file-name is nil")))

  (defun run-cpp-fsanitize ()
    (interactive)
    (if buffer-file-name
        (let ((filename (file-name-sans-extension (file-name-nondirectory buffer-file-name)))
              (dir (if (doom-project-root) (doom-project-root) (file-name-directory buffer-file-name))))
          (run-in-vterm (concat "cd " dir " && " "clang++ -O2 -std=c++17 -fsanitize=undefined " buffer-file-name " -o /tmp/cpp-" filename " && /tmp/cpp-" filename)))
      (message "buffer-file-name is nil"))))
