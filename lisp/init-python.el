;; -*- coding: utf-8; lexical-binding: t; -*-

(setq interpreter-mode-alist
      (cons '("python" . python-mode) interpreter-mode-alist))

(eval-after-load 'python
  '(progn
     (require 'lsp-python-ms)
     ;; for executable of language server, if it's not symlinked on your PATH
     (setq lsp-python-ms-executable
           "~/src/python-language-server/output/bin/Release/linux-x64/publish/Microsoft.Python.LanguageServer")
     ;; run command `pip install jedi flake8 importmagic` in shell,
     ;; or just check https://github.com/jorgenschaefer/elpy
     ;; (unless (or (is-buffer-file-temp)
     ;;             (not buffer-file-name)
     ;;             ;; embed python code in org file
     ;;             (string= (file-name-extension buffer-file-name) "org"))
     ;;   (elpy-enable))
     ;; http://emacs.stackexchange.com/questions/3322/python-auto-indent-problem/3338#3338
     ;; emacs 24.4 only
     (setq electric-indent-chars (delq ?: electric-indent-chars))))

(provide 'init-python)
