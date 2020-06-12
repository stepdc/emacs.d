;; -*- coding: utf-8; lexical-binding: t; -*-
;; flaymake go config
(local-require 'flymake-go-staticcheck)
(add-hook 'go-mode-hook #'flymake-go-staticcheck-enable)

(local-require 'lazyflymake)
(with-eval-after-load 'flymake
  (setq flymake-gui-warnings-enabled nil)
  ;;(remove-hook 'flymake-diagnostic-functions 'flymake-proc-legacy-flymake)
  )

(add-hook 'prog-mode-hook #'lazyflymake-start)

(provide 'init-flymake)
