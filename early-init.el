 ;; -*- lexical-binding: t; -*-


(setq gc-cons-threshold (* 50 1000 1000))
(menu-bar-mode   -1)
(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)

(setq inhibit-startup-screen t)

(defalias 'yes-or-no-p 'y-or-n-p)

;; Make native compilation happens asynchronously
(setq native-comp-deferred-compilation t)
(setq native-comp-async-report-warnings-errors nil)
(setq initial-scratch-message nil)
(setq inhibit-compacting-font-caches t)
(setq initial-major-mode 'fundamental-mode)

(setq display-line-numbers-type 'relative) 
(global-display-line-numbers-mode)
;; for built in completion only, no longer needed since went with Vertico
;; (setq completion-auto-select 'second-tab)

(load-file (locate-user-emacs-file "my/global-keys.el"))

;; (setq treesit-extra-load-path '("/home/lzhou/code/oss/tree-sitter-module/dist"))


( setq custom-file (locate-user-emacs-file "custom-vars.el") )

(global-auto-revert-mode 1)
( setq use-dialog-box nil )

(add-hook 'emacs-startup-hook
  (lambda ()
    (message "Emacs ready in %s with %d garbage collections."
      (format "%.2f seconds"
        (float-time
          (time-subtract
            after-init-time before-init-time)))
      gcs-done)))

(provide 'early-init)
;;; early-init.el ends here
