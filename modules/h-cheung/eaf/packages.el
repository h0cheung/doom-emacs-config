;; -*- no-byte-compile: t; -*-
;;; h-cheung/eaf/packages.el
(defun +eaf-install-deps-for-app(app-dir)
  "Install deps from dependencies.json."
  (let* ((deps-dict (with-temp-buffer
                      (insert-file-contents
                       (expand-file-name "dependencies.json" app-dir))
                      (json-parse-string (buffer-string))))
         (pip-deps (gethash (if IS-LINUX "linux" "darwin")
                            (or (gethash "pip" deps-dict)
                                (make-hash-table))))
         (vue-install (gethash "vue_install" deps-dict))
         (npm-install (gethash "npm_install" deps-dict))
         (npm-rebuild (gethash "npm_rebuild" deps-dict)))
    (when pip-deps
      (dolist (pkg (append pip-deps nil))
        (message "%s" (shell-command-to-string (format "pip install %s" pkg)))))
    (when vue-install
      (let ((default-directory app-dir))
        (message "%s" (shell-command-to-string "npm install"))
        (message "%s" (shell-command-to-string "npm run build"))))
    (when npm-install
      (let ((default-directory app-dir))
        (message "%s" (shell-command-to-string "npm install"))))
    (when npm-rebuild
      (let ((default-directory app-dir))
        (message "%s" (shell-command-to-string "npm rebuild"))))))

(package! eaf
  :recipe (:host github :repo "emacs-eaf/emacs-application-framework"
           :files ("*")
           :post-build
           (shell-command "python install-eaf.py --install-core-deps")))

(package! eaf-browser
  :recipe (:host github :repo "emacs-eaf/eaf-browser"
           :files ("*")
           :post-build
           (+eaf-install-deps-for-app
            (concat straight-base-dir "/straight/" straight-build-dir "/eaf-browser"))))
