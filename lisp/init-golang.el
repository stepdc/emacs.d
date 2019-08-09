(defun my-golang-setup ()
  "setup golang mode"
  (progn
    (setq tab-width 8)
    (setq standard-indent 8)
    (setq gofmt-command "goimports")

    (if (not (string-match "go" compile-command))
        (set (make-local-variable 'compile-command)
             "go generate && go install -v && go test -v && go vet"))
    (add-hook 'go-mode-hook 'flycheck-mode)
    (add-hook 'before-save-hook 'gofmt-before-save)
    (define-key evil-normal-state-map (kbd "C-]") 'godef-jump)))

(add-hook 'go-mode-hook 'my-golang-setup)

(provide 'init-golang)