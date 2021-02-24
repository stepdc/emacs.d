;; ui
(setq lsp-ui-doc-position 'top
      lsp-ui-doc-border (face-foreground 'default)
      lsp-ui-sideline-enable t
 )

(eval-after-load 'lsp
  '(progn
     (setq lsp-auto-guess-root t)
     (setq lsp-inhibit-message t)
     (setq lsp-message-project-root-warning t)
     (setq lsp-prefer-flymake nil)
     (setq lsp-clients-go-command "~/go/bin/gopls")

     ;; performance
     ;; (setq lsp-enable-file-watchers nil)
     ;; (setq lsp-print-performance t)
     (setq lsp-idle-delay 1)
     (setq lsp-completion-provider :capf)
     (setq lsp-log-io nil)

     (define-key prog-mode-map (kbd "S-<f6>") 'lsp-rename)))

;; toggle lsp ui doc
(defun toggle-lsp-ui-doc ()
  (interactive)
  (if lsp-ui-doc-mode
      (progn
        (lsp-ui-doc-mode -1)
        (lsp-ui-doc--hide-frame))
    (lsp-ui-doc-mode 1)))

(defun my-lsp-ui-mode-hook ()
  ;; delete-lsp-ui-doc frame is exists, and disable lsp-ui-doc by default
  (lsp-ui-doc--hide-frame)
  (lsp-ui-doc-mode -1))
(add-hook 'lsp-ui-mode-hook #'my-lsp-ui-mode-hook)

(global-set-key (kbd "S-<f5>") #'toggle-lsp-ui-doc)

(add-hook 'prog-mode-hook #'lsp-deferred)
(add-hook 'rust-mode-hook #'lsp-deferred)
(add-hook 'python-mode-hook #'lsp-deferred)

(provide 'init-lsp)
