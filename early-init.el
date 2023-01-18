(setq inhibit-startup-screen t)

(setq native-comp-deferred-compilation t)
(setq native-comp-async-report-warnings-errors nil)

(setq treesit-extra-load-path '("/home/lzhou/code/oss/tree-sitter-module/dist"))

( setq custom-file (locate-user-emacs-file "custom-vars.el") )

(global-auto-revert-mode 1)
( setq use-dialog-box nil )
(provide 'early-init)
;;; early-init.el ends here
