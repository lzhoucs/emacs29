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

;; for built in completion only, no longer needed since went with Vertico
;; (setq completion-auto-select 'second-tab)

;; clear electric-newline-and-maybe-indent, rarely used
(define-key global-map (kbd "C-j") nil)

;; clear undo, only keep C-/ for meow
(define-key global-map (kbd "C-_") nil)
(define-key global-map (kbd "C-x u") nil)
;; clear redo, use U for redo
(define-key global-map (kbd "C-?") nil)
(define-key global-map (kbd "C-M-_") nil)

;; clear negative-argument, can still be accessed from either C-u -, -(meow normal state map)
(define-key global-map (kbd "C--") nil)
(define-key global-map (kbd "M--") nil)
(define-key global-map (kbd "C-M--") nil)

;; clear backward-kill-word, can still be accessed from M-<backspace>
(define-key global-map (kbd "C-<backspace>") nil)

;; clear suspend-frame
(define-key global-map (kbd "C-z") nil)
(define-key global-map (kbd "C-x C-z") nil)


;; (define-key global-map (kbd "C-<tab>") 'other-window)
(define-key global-map (kbd "C-=") 'text-scale-increase)
(define-key global-map (kbd "C--") 'text-scale-decrease)

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
