;; {{ my configs
;; disable cursor blink in terminal
(setq visible-cursor nil)

;; evil edit status settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Customized functions               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;

(add-hook 'prog-mode-hook
          (lambda ()
            (define-key evil-normal-state-map (kbd "C-]") 'xref-find-definitions)
            (define-key prog-mode-map (kbd "S-<f6>") 'eglot-rename)
            (define-key prog-mode-map (kbd "S-<f5>") 'eglot)
            ;; (define-key prog-mode-map (kbd "S-<f6>") 'nox-rename)
            ;; (define-key prog-mode-map (kbd "S-<f5>") 'nox)
            ;; (define-key prog-mode-map (kbd "S-<f6>") 'lsp-rename)
            ;; (define-key prog-mode-map (kbd "S-<f5>") 'lsp)
            ;; (global-set-key (kbd "C-c l") 'my-imenu-or-list-tag-in-current-file)
            (global-set-key (kbd "C-c l") 'counsel-imenu)
            (global-set-key (kbd "C-x o") 'other-window)
            ))

;; evil state color {{
;; {{ change mode-line color by evil state
(defconst stepdc-default-color (cons "#98CE8F" "#424242"))
(defun stepdc-show-evil-state ()
  "Change mode line color to notify user evil current state."
  (let* ((color (cond ((minibufferp) stepdc-default-color)
                      ((evil-insert-state-p) '("#98ece8" . "#424242"))
                      ((evil-emacs-state-p)  '("#c1e7f8" . "#424242"))
                      ((buffer-modified-p)   '("#b85c57" . "#ffffff"))
                      (t stepdc-default-color))))
    (set-face-background 'mode-line (car color))
    (set-face-foreground 'mode-line (cdr color))))
(advice-add 'my-show-evil-state :override #'stepdc-show-evil-state)
;; }}
(set-fringe-mode 0)

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
;; (local-require 'eshell-toggle)
;; (global-set-key (kbd "M-t") 'eshell-toggle)

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
           company-idle-delay 0.0083
           ;; company-idle-delay 0.05
           company-echo-delay 0
           company-clang-insert-arguments nil
           company-require-match nil
           company-ctags-ignore-case nil ; I use company-ctags instead
           ;; company-ctags-fuzzy-match-p t
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

     (define-key company-active-map (kbd "TAB") #'company-complete-common-or-cycle)
     (define-key company-active-map (kbd "<tab>") #'company-complete-common-or-cycle)
     (define-key company-active-map (kbd "<backtab>") #'company-select-previous)
     (define-key company-active-map (kbd "S-TAB") #'company-select-previous)

     ;; Use the tab-and-go frontend.
     ;; Allows TAB to select and complete at the same time.
     ;; (company-tng-configure-default)
     ;; (setq company-frontends
     ;;       '(company-tng-frontend
     ;;         company-pseudo-tooltip-frontend
     ;;         company-echo-metadata-frontend))

     (define-key company-active-map (kbd "C-j") #'company-select-next)
     (define-key company-active-map (kbd "C-k") #'company-select-previous)
     (define-key company-active-map (kbd "C-l") #'company-complete-selection)
     (define-key company-active-map (kbd "C-n") #'company-select-next)
     (define-key company-active-map (kbd "C-p") #'company-select-previous)
     (define-key company-active-map (kbd "C-f") #'company-complete-selection)
     (define-key company-active-map (kbd "C-w") #'kill-region)
     (define-key company-active-map (kbd "C-h") #'company-complete-selection)
     ;; (define-key company-active-map (kbd "<return>") #'company-complete-selection)
     ;; (define-key company-active-map (kbd "RET") #'company-complete-selection)

     ;; (add-to-list 'company-transformers #'delete-dups)

     ;; Add yasnippet support for all company backends.
     (defvar company-mode/enable-yas t
       "Enable yasnippet for all backends.")

     (defun company-mode/backend-with-yas (backend)
       (if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)))
           backend
         (append (if (consp backend) backend (list backend))
                 '(:with company-yasnippet))))

     (setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))
     ))

;; (company-prescient-mode 1)

;; {{ tabnine
;; (with-eval-after-load 'company
;;   (require 'company-tabnine)
;;   (add-to-list 'company-backends #'company-tabnine))

;; }}

;; {{ ctags

;; (add-hook 'prog-mode-hook
;;           (lambda ()
;;             (add-to-list 'load-path "~/.emacs.d/site-lisp/citre")
;;             (require 'citre)
;;             (add-hook 'find-file-hook #'citre-auto-enable-citre-mode)
;;             ;; (require 'citre-config)
;;             (autoload 'citre-update-tags-file "citre")
;;             (autoload 'citre-update-this-tags-file "citre")
;;             (autoload 'citre-edit-tags-file-recipe "citre")
;;             (autoload 'citre-create-tags-file "citre")
;;             (autoload 'citre-mode "citre")
;;             (autoload 'citre-peek "citre")
;;             (autoload 'citre-ace-peek "citre")
;;             (autoload 'citre-auto-enable-citre-mode "citre")
;;             ))

;; }}

;; {{ playground
(exec-path-from-shell-initialize)
;; (local-require 'nox)

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
  (add-hook hook '(lambda () (eglot-ensure))))
  ;; (add-hook hook '(lambda () (nox-ensure))))
(setq eglot-ignored-server-capabilites '(:documentHighlightProvider))

;; use flymake gostatic check
;; (local-require 'flymake-go-staticcheck)
;; (add-hook 'go-mode-hook #'flymake-go-staticcheck-enable)

;; }}

;; {{ rust
(defun my-rust-setup ()
  (setq rust-format-on-save t)
  (setq indent-tabs-mode nil)

  (define-key rust-mode-map (kbd "C-c t f") 'rust-test)
  (define-key rust-mode-map (kbd "C-c t x") 'rust-run))

(add-hook 'rust-mode-hook 'my-rust-setup)
;; }}

;; {{ bing dict

(defun my-bing-dict-brief ()
  "print current word means."
  (interactive)
  (let (w  (thing-at-point 'word 'no-properties)))
  (bing-dict-brief w))

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

(setq my-disable-wucuo t)
;; }}

;; {{epubs
;; nov
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
(defun my-nov-setup ()
  (blink-cursor-mode 0)
  (face-remap-add-relative 'variable-pitch :family "charter"
                           :height 1.4)
  (dolist (charset '(kana han symbol cjk-misc bopomofo))
    (set-fontset-font (frame-parameter nil 'font)
                      charset (font-spec :family "FZYouSJ VF WT 1")))

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

  )
(add-hook 'nov-mode-hook 'my-nov-setup)

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
;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp/company-english-helper"))
;; (require 'company-english-helper)

(eval-after-load "dired" '(progn
                            (define-key dired-mode-map (kbd "t") 'counsel-fzf)
                            (define-key dired-mode-map (kbd "b") 'dired-toggle-marks)
                            ))

(local-require 'two-firewatch-light-theme)

(defun stepdc-gui-font-config ()
  ;; "set font to insconsolata"
  ;; (set-face-attribute 'default nil
  ;;                   :family "InconsolataGo"
  ;;                   :height 120
  ;;                   :weight 'normal
  ;;                   :width 'normal)
  (set-face-attribute 'default nil
                    :family "menlo"
                    :height 100
                    :weight 'normal
                    :width 'normal)
  )

;; Set default font
(my-run-with-idle-timer 1 #'stepdc-gui-font-config)

;; evil

;; stepdc custom bindings
(define-key evil-insert-state-map (kbd "C-c") 'evil-normal-state)

;; more bindings
(define-key evil-normal-state-map (kbd "SPC w") 'save-buffer)
(define-key evil-normal-state-map (kbd "SPC t") 'counsel-fzf)
;; (define-key evil-normal-state-map (kbd "SPC t") 'ffip)
(define-key evil-normal-state-map (kbd "SPC n") 'ivy-switch-buffer)
(define-key evil-normal-state-map (kbd "C-k") (lambda () (interactive) (previous-line 3)))
(define-key evil-normal-state-map (kbd "C-j") (lambda () (interactive) (next-line 3)))
(define-key evil-normal-state-map (kbd "K") (lambda () (interactive) (backward-paragraph)))
(define-key evil-normal-state-map (kbd "J") (lambda () (interactive) (forward-paragraph)))
(define-key evil-normal-state-map (kbd "C-l") (lambda () (interactive) (recenter-top-bottom) (evil-ex-nohighlight)))

;; c-w
(defun prelude-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first. If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

;; C-a
(define-key evil-insert-state-map (kbd "C-a") 'prelude-move-beginning-of-line)

;; global
(global-set-key (kbd "C-c r") 'my-counsel-recentf)

(defun evil-normalize-all-buffers ()
  "Force a drop to normal state."
  (unless (eq evil-state 'normal)
    (dolist (buffer (buffer-list))
      (set-buffer buffer)
      (unless (or (minibufferp)
                  (eq evil-state 'emacs))
        (evil-force-normal-state)))
    (message "Dropped back to normal state in all buffers")))

(my-run-with-idle-timer 20 #'evil-normalize-all-buffers)

;; hooks
;; (add-hook 'focus-in-hook
;;      #'evil-normal-state)
(add-hook 'prog-mode-hook #'hs-minor-mode)

(defun my-git-pos-and-state ()
  (goto-char 0)
  (evil-insert-state))

(add-hook 'git-commit-mode-hook 'my-git-pos-and-state)

;; {{ leetcode
;; (local-require 'leetcode)
;; (setq leetcode-prefer-language "go")
;; (setq leetcode-save-solutions t)
;; (setq leetcode-directory "~/Learn/leetcode")

;; }}

(provide 'init-stepdc)
