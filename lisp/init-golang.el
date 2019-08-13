(defun my-golang-setup ()
  "Setup golang mode"

    (if (not (string-match "go" compile-command))
        (set (make-local-variable 'compile-command)
             "go generate && go install -v && go test -v && go vet"))
    (setq gofmt-command "goimports")
    (setq tab-width 8)
    (setq standard-indent 8)
    (add-hook 'go-mode-hook 'flycheck-mode)
    (add-hook 'before-save-hook 'gofmt-before-save)
    (define-key evil-normal-state-map (kbd "C-]") 'godef-jump)

    (define-key go-mode-map (kbd "C-c t f") 'go-test-current-file)
    (define-key go-mode-map (kbd "C-c t t") 'go-test-current-test)
    (define-key go-mode-map (kbd "C-c t p") 'go-test-current-project)
    (define-key go-mode-map (kbd "C-c t b") 'go-test-current-benchmark)
    (define-key go-mode-map (kbd "C-c t x") 'go-run))

(add-hook 'go-mode-hook 'my-golang-setup)

(provide 'init-golang)