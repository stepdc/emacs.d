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
     (setq counsel-fzf-cmd "fd --type f | fzf -f \"%s\"")
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

     ;; Customize company backends.
     (setq company-backends (delete 'company-xcode company-backends))
     (setq company-backends (delete 'company-bbdb company-backends))
     (setq company-backends (delete 'company-eclim company-backends))
     (setq company-backends (delete 'company-gtags company-backends))
     (setq company-backends (delete 'company-etags company-backends))
     (setq company-backends (delete 'company-oddmuse company-backends))
     (add-to-list 'company-backends 'company-files)
     (setq company-minimum-prefix-length 1) ; pop up a completion menu by tapping a character

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

     ;; (defadvice company-echo-show (around disable-tabnine-upgrade-message activate)
     ;;   (let ((company-message-func (ad-get-arg 0)))
     ;;     (when (and company-message-func
     ;;                (stringp (funcall company-message-func)))
     ;;       (unless (string-match "The free version of TabNine only indexes up to" (funcall company-message-func))
     ;;         ad-do-it))))

     ;; workaround for company-transformers
     ;; (setq company-tabnine--disable-next-transform nil)
     ;; (defun my-company--transform-candidates (func &rest args)
     ;;   (if (not company-tabnine--disable-next-transform)
     ;;       (apply func args)
     ;;     (setq company-tabnine--disable-next-transform nil)
     ;;     (car args)))

     ;; (defun my-company-tabnine (func &rest args)
     ;;   (when (eq (car args) 'candidates)
     ;;     (setq company-tabnine--disable-next-transform t))
     ;;   (apply func args))

     ;; (advice-add #'company--transform-candidates :around #'my-company--transform-candidates)
     ;; (advice-add #'company-tabnine :around #'my-company-tabnine)

     ;; (add-to-list 'company-backends #'company-tabnine)
     ))

;; {{ mode-line
;; (require 'doom-modeline)
;; (doom-modeline-mode 1)
;; }}

;; {{ ctags

;; (local-require 'counsel-etags)
;; (defun my-setup-develop-environment ()
;;   "Set up my develop environment."
;;   (interactive)
;;   (unless (is-buffer-file-temp)
;;     (add-hook 'after-save-hook 'counsel-etags-virtual-update-tags 'append 'local)))
;; (add-hook 'prog-mode-hook 'my-setup-develop-environment)

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
;; (add-hook 'go-mode-hook 'eglot-ensure)


;; }}

;; {{ rust
(add-auto-mode 'rust-mode "\\.rs\\'")
(setq rust-format-on-save t)
;; }}

;; {{ bing dict

;; (defun my-bing-dict-brief ()
;;   "print current word means."
;;   (interactive)
;;   (let (w  (thing-at-point 'word 'no-properties)))
;;   (bing-dict-brief w))

(defun my-bing-dict-brief-direct (word)
  (interactive
   (let* ((default (if (use-region-p)
                       (buffer-substring-no-properties
                        (region-beginning) (region-end))
                     (let ((text (thing-at-point 'word)))
                       (if text
                           (substring-no-properties text)
                         (error "No point word found!"))))))
     (list default)))
  (bing-dict-brief word))

(global-set-key (kbd "C-c d") 'my-bing-dict-brief-direct)

(setq bing-dict-show-thesaurus 'both)
(setq bing-dict-vocabulary-save t)
(setq bing-dict-cache-auto-save t)

;; }}

;; {{epubs
;; (with-eval-after-load 'shr ; lazy load is very important, it can save you a lot of boot up time
;;   (require 'shrface)
;;   (shrface-basic) ; enable shrfaces, must be called before loading eww/dash-docs/nov.el
;;   (shrface-trial) ; enable shrface experimental face(s), must be called before loading eww/dash-docs/nov.el
;;   (setq shrface-href-versatile t) ; enable versatile URL faces support
;;                                         ; (http/https/ftp/file/mailto/other), if
;;                                         ; `shrface-href-versatile' is nil, default
;;                                         ; face `shrface-href-face' would be used.
;;   (setq shrface-toggle-bullets nil) ; Set t if you do not like headline bullets

;;   ;; eww support
;;   (with-eval-after-load 'eww
;;     (add-hook 'eww-after-render-hook 'shrface-mode))

;;   ;; nov support
;;   (with-eval-after-load 'nov
;;     (setq nov-shr-rendering-functions '((img . nov-render-img) (title . nov-render-title))) ; reset nov-shr-rendering-functions, in case of the list get bigger and bigger
;;     (setq nov-shr-rendering-functions (append nov-shr-rendering-functions shr-external-rendering-functions))
;;     (add-hook 'nov-mode-hook 'shrface-mode)))

;; nov
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
(defun my-nov-setup ()
   (blink-cursor-mode 0)
  (face-remap-add-relative 'variable-pitch :family "charter"
                           :height 1.4)
  (dolist (charset '(kana han symbol cjk-misc bopomofo))
    (set-fontset-font (frame-parameter nil 'font)
                      charset (font-spec :family "FZYouSJ VF WT 1")))
  )
(add-hook 'nov-mode-hook 'my-nov-setup)

;; {{ shrface related
;; (with-eval-after-load 'shr ; lazy load is very important, it can save you a lot of boot up time
;;   (require 'shrface)
;;   (shrface-basic) ; enable shrfaces, must be called before loading eww/dash-docs/nov.el
;;   (shrface-trial) ; enable shrface experimental face(s), must be called before loading eww/dash-docs/nov.el
;;   (setq shrface-href-versatile t) ; enable versatile URL faces support
;;                                   ; (http/https/ftp/file/mailto/other), if
;;                                   ; `shrface-href-versatile' is nil, default
;;                                   ; face `shrface-href-face' would be used.
;;   (setq shrface-toggle-bullets nil) ; Set t if you do not like headline bullets

;;   ;; eww support
;;   (with-eval-after-load 'eww
;;     (add-hook 'eww-after-render-hook 'shrface-mode))

;;   ;; nov support
;;   (with-eval-after-load 'nov
;;     (setq nov-shr-rendering-functions '((img . nov-render-img) (title . nov-render-title))) ; reset nov-shr-rendering-functions, in case of the list get bigger and bigger
;;     (setq nov-shr-rendering-functions (append nov-shr-rendering-functions shr-external-rendering-functions))
;;     (add-hook 'nov-mode-hook 'shrface-mode))

;;   ;; mu4e support
;;   (with-eval-after-load 'mu4e
;;     (add-hook 'mu4e-view-mode-hook 'shrface-mode)))
;; }} shrface ends here

(local-require 'justify-kp)
(setq nov-text-width t)

(defun my-nov-window-configuration-change-hook ()
  (my-nov-post-html-render-hook)
  (remove-hook 'window-configuration-change-hook
               'my-nov-window-configuration-change-hook
               t))

(defun my-nov-post-html-render-hook ()
  (if (get-buffer-window)
      (let ((max-width (pj-line-width))
            buffer-read-only)
        (save-excursion
          (goto-char (point-min))
          (while (not (eobp))
            (when (not (looking-at "^[[:space:]]*$"))
              (goto-char (line-end-position))
              (when (> (shr-pixel-column) max-width)
                (goto-char (line-beginning-position))
                (pj-justify)))
            (forward-line 1))))
    (add-hook 'window-configuration-change-hook
              'my-nov-window-configuration-change-hook
              nil t)))

(add-hook 'nov-post-html-render-hook 'my-nov-post-html-render-hook)

;; stop cursor blink in nov mode
;; (define-global-minor-mode my-global-cursor-mode blink-cursor-mode
;;   (lambda ()
;;     (when (memq major-mode
;;                      (list 'nov-mode))
;;       (blink-cursor-mode 0))))

;; (my-global-cursor-mode 1)

;; }}

(setq pyim-default-scheme 'xiaohe-shuangpin)

;; (local-require 'vterm)
;; (local-require 'vterm-toggle)
(add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp/company-english-helper"))
(require 'company-english-helper)

(provide 'init-stepdc)
