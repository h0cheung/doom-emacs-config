;;; h-cheung/ement/autoload.el -*- lexical-binding: t; -*-

;;;###autoload
(defun necronian-ement-sso-api (data)
  (let* ((id (cdr (assq 'user_id data)))
         (username (save-match-data
                     (string-match "@\\(.*\\):.*" id)
                     (match-string 1 id)))
         (server (cdr (assq 'home_server data)))
         (uri-prefix (cdr (assq 'base_url
                                (cdr (assq 'm\.homeserver
                                           (cdr (assq 'well_known data)))))))
         (token (cdr (assq 'access_token data))))
    (ement-connect
     :session (make-ement-session
               :user (make-ement-user :id id
                                      :username username)
               :server (make-ement-server :name server
                                          :uri-prefix uri-prefix)
               :token token
               :events (make-hash-table :test #'equal)
               :transaction-id (ement--initial-transaction-id)))))

;;;###autoload
(defun sso-login (uri-prefix proc msg)
  (let* ((token (save-match-data
                  (string-match "GET /\\?loginToken=\\(.*\\)\s.*" msg)
                  (match-string 1 msg)))
         (login-data (ement-alist "type" "m.login.token"
                                  "token" token)))
    (ement-api (make-ement-session
                :server (make-ement-server :uri-prefix uri-prefix))
      "login"
      :then #'necronian-ement-sso-api
      :method 'post
      :data (json-encode login-data))
    (delete-process "ement-sso")))

;;;###autoload
(defun ement-connect-sso (uri-prefix &optional local-port)
  "Connect to Matrix with Single Sign-On."
  (interactive
   (list
    (read-string "Server URI for SSO: " "https://")
    (read-number "Local port: " 4567)))
  (make-network-process
   :name "ement-sso"
   :family 'ipv4
   :host "localhost"
   :service (or local-port 4567)
   :filter (apply-partially #'sso-login uri-prefix)
   :server t)
  (browse-url (concat uri-prefix
                      "/_matrix/client/r0/login/sso/redirect?redirectUrl=http://localhost:"
                      (number-to-string (or local-port 4567)))))
