(add-hook 'after-init-hook #'global-flycheck-mode)

(defun my-go-flycheck-hook ()
  (setq flycheck-golangci-lint-fast t)
  (flycheck-golangci-lint-setup))

(eval-after-load 'flycheck
  '(add-hook 'go-mode-hook 'my-go-flycheck-hook))

(provide 'init-flycheck)