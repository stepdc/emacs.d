(eval-after-load 'lsp
  '(progn
     (setq lsp-auto-guess-root t)
     (setq lsp-inhibit-message t)
     (setq lsp-message-project-root-warning t)
     (setq lsp-prefer-flymake nil)
     (setq lsp-clients-go-command "~/go/bin/gopls")

     (setq company-lsp-cache-candidates 'auto)
     (push 'company-lsp company-backends)
     (setq company-lsp-async t)
     (define-key evil-normal-state-map (kbd "C-]") 'xref-find-definitions)
     (define-key prog-mode-map (kbd "S-<f6>") 'lsp-rename)
     ))

(eval-after-load 'company-lsp
  '(progn
     (defun company//sort-by-tabnine (candidates)
       (if (or (functionp company-backend)
               (not (and (listp company-backend) (memq 'company-tabnine company-backend))))
           candidates
         (let ((candidates-table (make-hash-table :test #'equal))
               candidates-1
               candidates-2)
           (dolist (candidate candidates)
             (if (eq (get-text-property 0 'company-backend candidate)
                     'company-tabnine)
                 (unless (gethash candidate candidates-table)
                   (push candidate candidates-2))
               (push candidate candidates-1)
               (puthash candidate t candidates-table)))
           (setq candidates-1 (nreverse candidates-1))
           (setq candidates-2 (nreverse candidates-2))
           (nconc (seq-take candidates-1 2)
                  (seq-take candidates-2 2)
                  (seq-drop candidates-1 2)
                  (seq-drop candidates-2 2)))))

     (add-to-list 'company-transformers 'company//sort-by-tabnine t)
     ;; `:separate`  使得不同 backend 分开排序
     (add-to-list 'company-backends '(company-lsp :with company-tabnine :separate))
     ))

(add-hook 'prog-mode-hook #'lsp-deferred)
(add-hook 'rust-mode-hook #'lsp-deferred)
(add-hook 'python-mode-hook #'lsp-deferred)

(provide 'init-lsp)