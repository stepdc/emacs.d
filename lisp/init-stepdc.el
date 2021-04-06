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
            (define-key prog-mode-map (kbd "S-<f6>") 'eglot-rename)
            (define-key prog-mode-map (kbd "S-<f5>") 'eglot)
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
           company-idle-delay 0.007
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

;; {{ tabnine
;; (with-eval-after-load 'company
;;   (require 'company-tabnine)
;;   (add-to-list 'company-backends #'company-tabnine)
;;   )

;; (with-eval-after-load 'company
;;   (dolist (mode (list
;;                  'c-mode-common
;;                  'c-mode
;;                  'emacs-lisp-mode
;;                  'lisp-interaction-mode
;;                  'lisp-mode
;;                  'java-mode
;;                  'asm-mode
;;                  'haskell-mode
;;                  'sh-mode
;;                  'makefile-gmake-mode
;;                  'python-mode
;;                  'js-mode
;;                  'html-mode
;;                  'css-mode
;;                  'tuareg-mode
;;                  'go-mode
;;                  'coffee-mode
;;                  'qml-mode
;;                  'slime-repl-mode
;;                  'package-menu-mode
;;                  'cmake-mode
;;                  'php-mode
;;                  'web-mode
;;                  'coffee-mode
;;                  'sws-mode
;;                  'jade-mode
;;                  'vala-mode
;;                  'rust-mode
;;                  'ruby-mode
;;                  'qmake-mode
;;                  'lua-mode
;;                  'swift-mode
;;                  'llvm-mode
;;                  'conf-toml-mode
;;                  'nxml-mode
;;                ))
;;   (with-eval-after-load mode
;;     (add-to-list 'company-backends #'company-tabnine))))
  ;; ( with-eval-after-load mode
  ;;   (setq +lsp-company-backends '(company-tabnine company-capf)))
  ;;   ))

(defun make-obsolete (obsolete-name current-name &optional when)
  "Make the byte-compiler warn that function OBSOLETE-NAME is obsolete.
OBSOLETE-NAME should be a function name or macro name (a symbol).

The warning will say that CURRENT-NAME should be used instead.
If CURRENT-NAME is a string, that is the `use instead' message
\(it should end with a period, and not start with a capital).
WHEN should be a string indicating when the function
was first made obsolete, for example a date or a release number."
  (declare (advertised-calling-convention
            ;; New code should always provide the `when' argument.
            (obsolete-name current-name when) "23.1"))
  (put obsolete-name 'byte-obsolete-info
       ;; The second entry used to hold the `byte-compile' handler, but
       ;; is not used any more nowadays.
       (purecopy (list current-name nil when)))
  obsolete-name)

(defmacro define-obsolete-function-alias (obsolete-name current-name
                                                        &optional when docstring)
  "Set OBSOLETE-NAME's function definition to CURRENT-NAME and mark it obsolete.

\(define-obsolete-function-alias \\='old-fun \\='new-fun \"22.1\" \"old-fun's doc.\")

is equivalent to the following two lines of code:

\(defalias \\='old-fun \\='new-fun \"old-fun's doc.\")
\(make-obsolete \\='old-fun \\='new-fun \"22.1\")

WHEN should be a string indicating when the function was first
made obsolete, for example a date or a release number.

See the docstrings of `defalias' and `make-obsolete' for more details."
  (declare (doc-string 4)
           (advertised-calling-convention
            ;; New code should always provide the `when' argument.
            (obsolete-name current-name when &optional docstring) "23.1"))
  `(progn
     (defalias ,obsolete-name ,current-name ,docstring)
     (make-obsolete ,obsolete-name ,current-name ,when)))

(defun make-obsolete-variable (obsolete-name current-name &optional when access-type)
  "Make the byte-compiler warn that OBSOLETE-NAME is obsolete.
The warning will say that CURRENT-NAME should be used instead.
If CURRENT-NAME is a string, that is the `use instead' message.
WHEN should be a string indicating when the variable
was first made obsolete, for example a date or a release number.
ACCESS-TYPE if non-nil should specify the kind of access that will trigger
  obsolescence warnings; it can be either `get' or `set'."
  (declare (advertised-calling-convention
            ;; New code should always provide the `when' argument.
            (obsolete-name current-name when &optional access-type) "23.1"))
  (put obsolete-name 'byte-obsolete-variable
       (purecopy (list current-name access-type when)))
  obsolete-name)

(defmacro define-obsolete-variable-alias (obsolete-name current-name
              &optional when docstring)
  "Make OBSOLETE-NAME a variable alias for CURRENT-NAME and mark it obsolete.
This uses `defvaralias' and `make-obsolete-variable' (which see).
See the Info node `(elisp)Variable Aliases' for more details.

If CURRENT-NAME is a defcustom or a defvar (more generally, any variable
where OBSOLETE-NAME may be set, e.g. in an init file, before the
alias is defined), then the define-obsolete-variable-alias
statement should be evaluated before the defcustom, if user
customizations are to be respected.  The simplest way to achieve
this is to place the alias statement before the defcustom (this
is not necessary for aliases that are autoloaded, or in files
dumped with Emacs).  This is so that any user customizations are
applied before the defcustom tries to initialize the
variable (this is due to the way `defvaralias' works).

WHEN should be a string indicating when the variable was first
made obsolete, for example a date or a release number.

For the benefit of Customize, if OBSOLETE-NAME has
any of the following properties, they are copied to
CURRENT-NAME, if it does not already have them:
`saved-value', `saved-variable-comment'."
  (declare (doc-string 4)
           (advertised-calling-convention
            ;; New code should always provide the `when' argument.
            (obsolete-name current-name when &optional docstring) "23.1"))
  `(progn
     (defvaralias ,obsolete-name ,current-name ,docstring)
     ;; See Bug#4706.
     (dolist (prop '(saved-value saved-variable-comment))
       (and (get ,obsolete-name prop)
            (null (get ,current-name prop))
            (put ,current-name prop (get ,obsolete-name prop))))
     (make-obsolete-variable ,obsolete-name ,current-name ,when)))

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
  ;;(add-hook hook '(lambda () (nox-ensure))))
;; (add-hook 'go-mode-hook 'eglot-ensure)


;; }}

;; {{ rust
;; (add-auto-mode 'rust-mode "\\.rs\\'")
(setq rust-format-on-save t)
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
  "set font to insconsolata"
  (set-face-attribute 'default nil
                    :family "InconsolataGo"
                    :height 120
                    :weight 'normal
                    :width 'normal))

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

(defvar evil-normal-timer
  (run-with-idle-timer 30 t #'evil-normalize-all-buffers)
  "Drop back to normal state after idle for 15 seconds.")

;; hooks
;; (add-hook 'focus-in-hook
;;      #'evil-normal-state)
(add-hook 'prog-mode-hook #'hs-minor-mode)

(provide 'init-stepdc)
