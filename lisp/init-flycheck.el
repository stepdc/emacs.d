(add-hook 'after-init-hook #'global-flycheck-mode)

;; (defun my-go-flycheck-hook ()
;;   ;; (add-hook 'after-save-hook
;;   ;;     (lambda ()
;;   ;;       (if (eq major-mode 'go-mode)
;;   ;;           (flycheck-compile 'go-build))))

;;   ;; (flycheck-golangci-lint-setup)
;;   (setq flycheck-golangci-lint-fast t)
;;   (setq flycheck-golangci-lint-enable-linters '("govet"
;;                                                 "errcheck"
;;                                                 "structcheck"
;;                                                 "varcheck"
;;                                                 "unused"
;;                                                 "deadcode"
;;                                                 "typecheck"
;;                                                 "staticcheck"
;;                                                 "gosimple"
;;                                                 "goimports"
;;                                                 "golint"
;;                                                 "gocyclo"
;;                                                 "misspell"))

;;   )

;; (with-eval-after-load 'go-mode
;;   (add-hook 'flycheck-mode-hook #'my-go-flycheck-hook))

(with-eval-after-load 'rust-mode
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

(provide 'init-flycheck)