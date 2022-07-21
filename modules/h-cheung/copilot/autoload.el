;;; h-cheung/copilot/autoload.el -*- lexical-binding: t; -*-

;;;###autoload
(defun copilot-accept-or-forward ()
  "Accept copilot completion or jumps"
  (interactive "^")
  (or (copilot-accept-completion)
      (doom/forward-to-last-non-comment-or-eol)))
