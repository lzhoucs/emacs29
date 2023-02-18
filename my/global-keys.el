;;; global-keys.el -*- lexical-binding: t; -*-


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
(define-key global-map (kbd "C-=") #'text-scale-increase)
(define-key global-map (kbd "C--") #'text-scale-decrease)

;; helpful keybindings
(global-set-key (kbd "C-h f") #'helpful-callable)
(global-set-key (kbd "C-h v") #'helpful-variable)
(global-set-key (kbd "C-h k") #'helpful-key)

;; useful in lisp mode only
(global-set-key (kbd "C-c C-d") #'helpful-at-point)

;; window
(global-set-key (kbd "C-x 1") nil)
;; (global-set-key (kbd "C-x w o") #'delete-other-windows)

(global-set-key (kbd "C-x w 2") nil)
;; (global-set-key (kbd "C-x w V") #'split-root-window-below)

(global-set-key (kbd "C-x w 3") nil)
;; (global-set-key (kbd "C-x w v") #'split-root-window-right)
