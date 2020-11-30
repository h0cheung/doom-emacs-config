;;; h-cheung/telega/config.el -*- lexical-binding: t; -*-

;; copied form cnsunyour and StreamedFish

;; telegram client for emacs
(use-package! telega
  :commands (telega)
  :defer t
  :bind ("C-M-S-s-t" . #'telega)
  :custom
  ;; (telega-proxies (list '(:server "127.0.0.1" :port 1086 :enable t
  ;;                         :type (:@type "proxyTypeSocks5"))))
  (telega-chat-reply-prompt "<<< ")
  (telega-chat-edit-prompt "+++ ")
  (telega-sticker-size '(8 . 48))
  (telega-chat-use-markdown-version nil)
  (telega-animation-play-inline t)
  (telega-emoji-use-images nil)
  (telega-sticker-set-download t)
 ;; (telega-use-tracking-for '(or pin (label "⌘")))
  (telega-chat-show-deleted-messages-for '(all))
  :init
  (setq telega-use-images (or (display-graphic-p) (daemonp)))

  (when (featurep! :completion ivy)
    (load! "+ivy-telega"))

  :hook
  (telega-chat-mode . yas-minor-mode-on)
  (telega-chat-mode . visual-line-mode)
  (telega-chat-mode . (lambda ()
                        (set-company-backend! 'telega-chat-mode
                          (append '(telega-company-emoji
                                    telega-company-username
                                    telega-company-hashtag)
                                  (when (telega-chat-bot-p telega-chatbuf--chat)
                                    '(telega-company-botcmd))))))
  (telega-chat-pre-message . telega-msg-ignore-blocked-sender)
  :config

  (when (featurep! +auto-method)
    (load! "+telega-auto-method"))

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
      "RET"              #'+default/newline-below
      "<C-return>"       #'telega-chatbuf-input-send))

  (pushnew! telega-known-inline-bots
            "@vid" "@bing" "@wiki" "@imdb")

  (set-popup-rule! (regexp-quote telega-root-buffer-name)
    :ignore t)
  ;; (set-popup-rule! "^◀[^◀\[]*[\[({<].+[\])}>]"
  ;;   :side 'right :size 100 :select t :ttl 300 :quit nil :modeline t)

  (telega-mode-line-mode 1)
  (telega-url-shorten-mode 1)
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
  (load! "+telega-addition"))
  ;; (advice-add 'telega-root--killed :around (lambda ())))
  ;; (when (daemonp)
  ;;   (telega nil)))