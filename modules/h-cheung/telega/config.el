;;; h-cheung/telega/config.el -*- lexical-binding: t; -*-

;; copied form cnsunyour and StreamedFish

;; telegram client for emacs
(use-package! telega
  :defer t
  :custom
  ;; (telega-proxies (list '(:server "127.0.0.1" :port 1086 :enable t
  ;;                         :type (:@type "proxyTypeSocks5"))))
  ;; (telega-open-file-function 'org-open-file)
  (telega-chat-input-prompt '((prompt . ">>> ")
                              (reply . "<<< ")
                              (edit . "+++ ")))
  (telega-chat-input-anonymous-prompt '((prompt . "Anonymous>>> ")
                                        (reply . "Anonymous<<< ")
                                        (edit . "Anonymous+++ ")))
  (telega-chat-input-comment-prompt '((prompt . "Comment>>> ")
                                      (reply . "Comment<<< ")
                                      (edit . "Comment+++ ")))
  ;; (telega-sticker-size '(8 . 48))
  (telega-animation-play-inline t)
  (telega-emoji-use-images nil)
  (telega-sticker-set-download t)
  (telega-chat-show-deleted-messages-for '(all))
  (telega-symbol-folder "📁")
  (telega-emoji-company-backend 'telega-company-telegram-emoji)

  :init
  (setq telega-use-images (or (display-graphic-p) (daemonp)))

  :hook
  (telega-chat-mode . yas-minor-mode-on)
  ;; (telega-chat-mode . visual-line-mode)
  (telega-chat-mode . (lambda ()
                        (set-company-backend! 'telega-chat-mode
                          (append '(telega-company-emoji
                                    telega-company-username
                                    telega-company-hashtag)
                                  (when (telega-chat-bot-p telega-chatbuf--chat)
                                    '(telega-company-botcmd))))))
  (telega-load . telega-mode-line-mode)
  (telega-load . global-telega-url-shorten-mode)
  (telega-load . global-telega-mnz-mode)
  (telega-load . telega-autoplay-mode)

  :config
  (setq telega-mode-line-string-format
        (cl-remove '(:eval (telega-mode-line-icon))
                   telega-mode-line-string-format
                   :test #'equal))
  (add-hook 'telega-msg-ignore-predicates 'telega-msg-from-blocked-sender-p)

  (when (featurep! +auto-im)
    (load! "+telega-auto-im"))

                                        ; (set-evil-initial-state! '(telega-root-mode telega-chat-mode) 'emacs)
  (when (featurep! :editor evil)
    (map!
     (:map telega-msg-button-map
      "J" #'telega-button-forward
      "k" nil
      "K" #'telega-button-backward
      "p" #'telega-msg-redisplay
      "l" nil))
    (map!
     :map telega-chat-button-map
     "h" nil))

  ;; use RET to add newline and C-RET to send
  (when (featurep! :config default)
    (map! :map telega-chat-mode-map
          "C-c C-t"          #'telega-chatbuf-attach-sticker
          "RET"              nil
          "<C-return>"       #'telega-chatbuf-input-send))

  (map! :map global-map
        :desc "telega" "C-c t" telega-prefix-map)

  (set-popup-rule! (regexp-quote telega-root-buffer-name)
    :ignore t)
  ;; (set-popup-rule! "^◀[^◀\[]*[\[({<].+[\])}>]"
  ;;   :side 'right :size 100 :select t :ttl 300 :quit nil :modeline t)

  (when (and IS-LINUX (boundp 'dbus-runtime-version))
    (telega-notifications-mode 1))

  (after! all-the-icons
    (add-to-list 'all-the-icons-mode-icon-alist
                 '(telega-root-mode all-the-icons-fileicon "telegram"
                                    :heigt 1.0
                                    :v-adjust -0.2
                                    :face all-the-icons-yellow))
    (add-to-list 'all-the-icons-mode-icon-alist
                 '(telega-chat-mode all-the-icons-fileicon "telegram"
                                    :heigt 1.0
                                    :v-adjust -0.2
                                    :face all-the-icons-blue)))
  (use-package! telega-stories
    :config
    (telega-stories-mode 1)
    (map! :map telega-root-mode-map "v e" 'telega-view-emacs-stories))

  (load! "+telega-addition"))
