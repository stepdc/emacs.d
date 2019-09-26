(add-hook 'after-init-hook #'global-flycheck-mode)

(defun my-go-flycheck-hook ()
  (flycheck-golangci-lint-setup)
  (setq flycheck-golangci-lint-fast t))

(with-eval-after-load 'go-mode
  (add-hook 'flycheck-mode-hook #'my-go-flycheck-hook))

(with-eval-after-load 'rust-mode
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

(provide 'init-flycheck)