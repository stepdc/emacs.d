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
        (set-face-attribute 'default nil :height 150))

;; }}

(eval-after-load 'counsel
  '(progn
     ;; ffip root
     (setq counsel-fzf-dir-function 'ffip-project-root)
     (setcdr (assoc 'counsel-M-x ivy-initial-inputs-alist) "")
     ;; (setq ivy-initial-inputs-alist nil)
     ))

;; {{
(eval-after-load 'python
  '(progn
     (setq lsp-python-ms-executable
           "~/src/python-language-server/output/bin/Release/linux-x64/publish/Microsoft.Python.LanguageServer")))
;; }}

(eval-after-load 'company
  '(progn
     (setq company-dabbrev-downcase nil
           ;; make previous/next selection in the popup cycles
           company-selection-wrap-around t
           ;; Some languages use camel case naming convention,
           ;; so company should be case sensitive.
           company-dabbrev-ignore-case nil
           ;; press M-number to choose candidate
           company-show-numbers t
           company-idle-delay 0
           company-echo-delay 0
           company-clang-insert-arguments nil
           company-require-match nil
           company-ctags-ignore-case t ; I use company-ctags instead
           ;; @see https://github.com/company-mode/company-mode/issues/146
           company-tooltip-align-annotations t)

     (define-key company-active-map (kbd "C-j") #'company-select-next)
     (define-key company-active-map (kbd "C-k") #'company-select-previous)
     (define-key company-active-map (kbd "C-l") #'company-complete-selection)
     (define-key company-active-map (kbd "C-n") #'company-select-next)
     (define-key company-active-map (kbd "C-p") #'company-select-previous)
     (define-key company-active-map (kbd "C-f") #'company-complete-selection)
     (define-key company-active-map (kbd "C-w") #'kill-region)
     (define-key company-active-map (kbd "TAB") #'company-complete-common-or-cycle)
     (define-key company-active-map (kbd "<tab>") #'company-complete-common-or-cycle)
     (define-key company-active-map (kbd "<backtab>") #'company-select-previous)
     (define-key company-active-map (kbd "S-TAB") #'company-select-previous)

     (defadvice company-echo-show (around disable-tabnine-upgrade-message activate)
       (let ((company-message-func (ad-get-arg 0)))
         (when (and company-message-func
                    (stringp (funcall company-message-func)))
           (unless (string-match "The free version of TabNine only indexes up to" (funcall company-message-func))
             ad-do-it))))
     (add-to-list 'company-backends #'company-tabnine)
     ))

;; {{ mode-line
;; (require 'doom-modeline)
;; (doom-modeline-mode 1)
;; }}

;; {{ ctags

;; (local-require 'counsel-etags)
(defun my-setup-develop-environment ()
  "Set up my develop environment."
  (interactive)
  (unless (is-buffer-file-temp)
	(add-hook 'after-save-hook 'counsel-etags-virtual-update-tags 'append 'local)))
(add-hook 'prog-mode-hook 'my-setup-develop-environment)

;; }}


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

;; {{ rust
(add-auto-mode 'rust-mode "\\.rs\\'")
(setq rust-format-on-save t)
;; }}



(provide 'init-stepdc)
