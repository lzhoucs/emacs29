 ;; -*- lexical-binding: t; -*-


(setq gc-cons-threshold (* 50 1000 1000))
(menu-bar-mode   -1)
(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)

(setq inhibit-startup-screen t)

;; Make native compilation happens asynchronously
(setq native-comp-deferred-compilation t)
(setq native-comp-async-report-warnings-errors nil)
(setq initial-scratch-message nil)
(setq inhibit-compacting-font-caches t)

;; (setq completion-auto-select 'second-tab)

(define-key global-map (kbd "C-<tab>") 'other-window)
(define-key global-map (kbd "C-=") 'text-scale-increase)
(define-key global-map (kbd "C--") 'text-scale-decrease)

(setq treesit-extra-load-path '("/home/lzhou/code/oss/tree-sitter-module/dist"))


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
