;; {{ my configs
;; disable cursor blink in terminal
(setq visible-cursor nil)

;; evil edit status settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Customized functions                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;

(add-hook 'prog-mode-hook
          (lambda ()
            (define-key evil-normal-state-map (kbd "C-]") 'xref-find-definitions)
            (define-key prog-mode-map (kbd "S-<f6>") 'lsp-rename)
            (global-set-key (kbd "C-c l") 'my-imenu-or-list-tag-in-current-file)))

(global-set-key (kbd "C-c k") 'counsel-rg)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "M-*") 'pop-tag-mark)

;;
(defadvice kill-region (before unix-werase activate compile)
      "When called interactively with no active region, delete a single word
    backwards instead."
      (interactive
       (if mark-active (list (region-beginning) (region-end))
         (list (save-excursion (backward-word 1) (point)) (point)))))

;; toggle-eshell
(local-require 'eshell-toggle)
(global-set-key (kbd "M-t") 'eshell-toggle)

(when *is-a-mac*
        (set-face-attribute 'default nil :height 140))

;; }}

(eval-after-load 'ivy
  '(progn
     ;; ffip root
     (setq counsel-fzf-dir-function 'ffip-project-root)
     (setcdr (assoc 'counsel-M-x ivy-initial-inputs-alist) "")
     (setq ivy-initial-inputs-alist nil)))

;; {{
(eval-after-load 'python
  '(progn
     (setq lsp-python-ms-executable
           "~/src/python-language-server/output/bin/Release/linux-x64/publish/Microsoft.Python.LanguageServer")))
;; }}

(eval-after-load 'company
  '(progn
     (add-to-list 'company-backends #'company-tabnine)
     ))

;; {{ playground
(exec-path-from-shell-initialize)
(local-require 'nox)

(dolist (hook (list
               'go-mode-hook
               'js-mode-hook
               'rust-mode-hook
               'python-mode-hook
               'ruby-mode-hook
               'java-mode-hook
               'sh-mode-hook
               'php-mode-hook
               'c-mode-common-hook
               'c-mode-hook
               'c++-mode-hook
               'haskell-mode-hook
               ))
  (add-hook hook '(lambda () (nox-ensure))))

;; }}

(provide 'init-stepdc)
