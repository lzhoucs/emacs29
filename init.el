 ;; -*- lexical-binding: t; -*-

(require 'package)

;; https://github.com/minad/consult/issues/451#issuecomment-1250066027
(setq package-archives '(("gnu-devel" . "https://elpa.gnu.org/devel/")
			 ("nongnu-devel" . "https://elpa.gnu.org/nongnu-devel/")
			 ("melpa-devel" . "https://melpa.org/packages/"))
      package-archive-priorities '(("gnu-devel" . 2)
				   ("nongnu-devel" . 1)
				   ("melpa-devel" . 0))
      package-archive-column-width 14
      package-version-column-width 26)

;; (setq package-archives '(
;;                          ;; ("org"   . "http://orgmode.org/elpa/")
;;                          ("gnu"   . "https://elpa.gnu.org/packages/")
;;                          ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

(require 'use-package)
(require 'use-package-ensure)
(setq use-package-always-ensure t)

;; Theme
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t))

;; (load-file (locate-user-emacs-file "my/meow.el"))
(load-file (locate-user-emacs-file "my/elisp.el"))

;; Enable vertico
(use-package vertico
  :bind (:map vertico-map
         ("C-l" . vertico-insert)
         ("C-<backspace>" . backspace-kill-word)
         ("C-j" . nil)
         )
  :init
  ;; (unbind-key "C-j" vertico-map)
  (vertico-mode)
  (vertico-buffer-mode)
  ;; (vertico-buffer-display-action . (display-buffer-in-side-window (side . right)))
  ;; (setq vertico-multiform-commands
  ;;       '(
  ;;         (consult-ripgrep buffer (vertico-buffer-display-action . (display-buffer-in-side-window (side . right))))
  ;;         (consult-grep buffer (vertico-buffer-display-action . (display-buffer-in-side-window (side . right))))
  ;;         ;; (my-consult-project-ripgrep buffer (vertico-buffer-display-action . (display-buffer-in-side-window (side . right) (window-width . 1))))
  ;;         (my-consult-project-ripgrep buffer)
  ;;         ;; (consult-info buffer (vertico-buffer-display-action . (display-buffer-in-side-window (side . right))))
  ;;         ;; (consult-project-buffer buffer (vertico-buffer-display-action . (display-buffer-in-side-window (side . right))))
  ;;         ;; (consult-buffer buffer (vertico-buffer-display-action . (display-buffer-in-side-window (side . right))))
  ;;         ;; (t reverse)
  ;;         ))
  ;; (setq vertico-multiform-categories
  ;; 	'(
  ;; ;; 	  ;; (consult-buffer buffer (vertico-buffer-display-action . (display-buffer-in-side-window (side . right))))
  ;; ;; 	  ;; (consult-grep buffer (vertico-buffer-display-action . (display-buffer-in-side-window (side . right))))
  ;; 	  (t reverse)))
  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  (setq vertico-cycle t)
  )

;; Example configuration for Consult
(use-package consult
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :bind (
         ([remap Info-search] . consult-info)
	 )
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config
  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

  ;; By default `consult-project-function' uses `project-root' from project.el.
  ;; Optionally configure a different project root function.
  ;; There are multiple reasonable alternatives to chose from.
  ;;;; 1. project.el (the default)
  ;; (setq consult-project-function #'consult--default-project--function)
  ;;;; 2. projectile.el (projectile-project-root)
  ;; (autoload 'projectile-project-root "projectile")
  ;; (setq consult-project-function (lambda (_) (projectile-project-root)))
  ;;;; 3. vc.el (vc-root-dir)
  ;; (setq consult-project-function (lambda (_) (vc-root-dir)))
  ;;;; 4. locate-dominating-file
  ;; (setq consult-project-function (lambda (_) (locate-dominating-file "." ".git")))
)

(use-package embark
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ;; ("C-h B" . embark-bindings) ;; alternative for `describe-bindings'
   )

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; Enable rich annotations using the Marginalia package
(use-package marginalia
  :after vertico
  ;; :bind (:map minibuffer-local-map
  ;;        ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

(use-package orderless
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        orderless-component-separator #'orderless-escapable-split-on-space
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package company
  :config
  (global-company-mode 1)
  )

;; A few more useful configurations...
(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t)

  (electric-pair-mode)
  )

;; for treesit-install-language-grammar command
(setq treesit-language-source-alist
  '((bash "https://github.com/tree-sitter/tree-sitter-bash")
    (c "https://github.com/tree-sitter/tree-sitter-c")
    (cmake "https://github.com/uyha/tree-sitter-cmake")
    (common-lisp "https://github.com/theHamsta/tree-sitter-commonlisp")
    (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
    (css "https://github.com/tree-sitter/tree-sitter-css")
    (csharp "https://github.com/tree-sitter/tree-sitter-c-sharp")
    (elisp "https://github.com/Wilfred/tree-sitter-elisp")
    (go "https://github.com/tree-sitter/tree-sitter-go")
    (go-mod "https://github.com/camdencheek/tree-sitter-go-mod")
    (html "https://github.com/tree-sitter/tree-sitter-html")
    (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript" "master" "src"))
    (json "https://github.com/tree-sitter/tree-sitter-json")
    (lua "https://github.com/Azganoth/tree-sitter-lua")
    (make "https://github.com/alemuller/tree-sitter-make")
    (markdown "https://github.com/ikatyang/tree-sitter-markdown")
    (python "https://github.com/tree-sitter/tree-sitter-python")
    (r "https://github.com/r-lib/tree-sitter-r")
    (rust "https://github.com/tree-sitter/tree-sitter-rust")
    (toml "https://github.com/tree-sitter/tree-sitter-toml")
    (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src"))
    (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src"))
    (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

(use-package project
  ;; https://github.com/magit/magit/blob/main/lisp/magit-extras.el#L236-L246
  ;; https://mastodon.social/@ctietze/109748735976228771
  :bind (:map project-prefix-map
         ("m" . magit-project-status)
         ("/" . my-consult-project-ripgrep)
         ("b" . consult-project-buffer)
         )
  :config
  (setq project-switch-commands '(
                                  (project-find-file "Find file")
                                  (magit-project-status "Magit")
                                  (my-consult-project-ripgrep "ripgrep")
                                  (consult-project-buffer "Find buffer")
                                  ))
  )
(use-package magit
  :config
  (setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  )

;; manually map original non treesit mode to treesit mode(*-ts-mode)
;; this only works when original non treesit mode are auto loaded which isn't the case for typescript because the mode (typescript-mode) itself is not installed
;; (add-to-list 'major-mode-remap-alist '(typescript-mode . typescript-ts-mode))
;; works well
(add-to-list 'major-mode-remap-alist '(js-json-mode . json-ts-mode))
(add-to-list 'major-mode-remap-alist '(scss-mode . css-ts-mode))
;; does not work
;; (add-to-list 'major-mode-remap-alist '(js-mode . js-ts-mode))

;; this approach works better since it doesn't require original mode to be installed
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js-ts-mode))
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))

(add-hook 'typescript-ts-mode-hook 'eglot-ensure)
(add-hook 'js-ts-mode-hook 'eglot-ensure)
(add-hook 'rust-ts-mode-hook 'eglot-ensure)
(add-hook 'css-ts-mode-hook 'eglot-ensure)


;; built in package
(use-package eglot
  :bind (:map eglot-mode-map
         ("C-c r" . eglot-rename)
         ("C-c o" . eglot-code-action-organize-imports)
         ("C-c h" . eldoc)
         ("C-c d" . xref-find-definitions)
         ("C-c t" . eglot-find-typeDefinition)
        )
  :config
  (add-to-list 'eglot-server-programs
	       ;; default has rls which is deprecated, so this line fixes the prompt of "more than one server executable available"
	       '(rust-ts-mode . ("rust-analyzer")))
  )


(use-package helpful)

(use-package popup)
(use-package pyim-basedict)
(use-package pyim
  :init
  (require 'popup)
  (require 'pyim)
  (require 'pyim-basedict) ; 拼音词库设置，五笔用户 *不需要* 此行设置
  (pyim-basedict-enable)   ; 拼音词库，五笔用户 *不需要* 此行设置
  (setq default-input-method "pyim")
  ;; 设置 pyim 默认使用的输入法策略，我使用全拼。
  (pyim-default-scheme 'quanpin) ;; 'wubi 'cangjie
  ;; 设置 pyim 是否使用云拼音
  ;; (setq pyim-cloudim 'baidu) ;; 'google
  )

;; (use-package modalka

;;   ;; :bind (:map modalka-mode-map
;;   ;;        ("C-x C-g" . execute-extended-command)
;;   ;;        )

;;   :config
;;   (define-key modalka-mode-map (kbd "SPC") ctl-x-map)
;;   (define-key modalka-mode-map (kbd "SPC SPC") mode-specific-map)
;;   (define-key modalka-mode-map (kbd "SPC :") #'execute-extended-command)

;;   (setq modalka-excluded-modes '(
;;                                          magit-status-mode
;;                                          Info-mode
;;                                          dired-mode
;;                                          ))

;;   (modalka-global-mode 1)
;;   )


;; (setq viper-mode t)
;; (require 'viper)

(use-package dirvish
  :config
  (dirvish-override-dired-mode)
  )

;; see: http://traeki.freeshell.org/files/viper-sample
;; (use-package viper
;;   :init
;;   (setq viper-expert-level '5)
;;   (setq viper-inhibit-startup-message 't)
;;   (setq viper-want-ctl-h-help 't)
;;   (setq viper-mode t)
;;   (require 'viper)
;;   )

(use-package undo-fu)
(use-package evil
  :init
  ;; (setq evil-want-C-w-delete nil) ;; not necessary when we set C-w to nil
  (setq evil-want-fine-undo t)
  (setq evil-undo-system 'undo-fu)
  (setq evil-intercept-esc 't) ;; terminal only
  (setq evil-inhibit-esc t)
  ;; should try and consider
  ;; evil-cross-lines
  :config
  ;; root
  (evil-define-key 'normal 'global (kbd "q") #'evil-quit)
  (evil-set-leader '(normal motion visual replace operator) (kbd "SPC"))
  ;; leader root
  (evil-define-key 'normal 'global (kbd "<leader>:") #'execute-extended-command)
  (evil-define-key 'normal 'global (kbd "<leader>q") #'evil-record-macro)
  (evil-define-key 'normal 'global (kbd "<leader><tab>") #'evil-switch-to-windows-last-buffer)
  (evil-define-key 'normal 'global (kbd "<leader>/") #'consult-ripgrep)
  ;; b buffer
  (evil-define-key 'normal 'global (kbd "<leader>bb") #'consult-buffer)
  (evil-define-key 'normal 'global (kbd "<leader>bd") #'kill-current-buffer)
  ;; p project
  (evil-define-key 'normal 'global (kbd "<leader>p") project-prefix-map)
  (evil-define-key 'normal 'global (kbd "<leader>px") nil)
  (evil-define-key 'normal 'global (kbd "<leader>p:") #'project-execute-extended-command)
  ;; w window
  ;; don't need it, use leader-w instead. Note because normal state reuse keys from motion state, we need to find and set it in the "root"
  (evil-define-key 'motion 'global (kbd "C-w") nil)
  (evil-define-key 'normal 'global (kbd "<leader>w") evil-window-map)
  ;; f file
  (evil-define-key 'normal 'global (kbd "<leader>fs") #'save-buffer)
  (evil-define-key 'normal 'global (kbd "<leader>ff") #'find-file)
  ;; i info
  (evil-define-key 'normal 'global (kbd "<leader>ii") #'consult-info)
  (evil-define-key 'normal 'global (kbd "<leader>ie") #'consult-info-emacs)
  (evil-define-key 'normal 'global (kbd "<leader>io") #'consult-info-org)
  (evil-define-key 'normal 'global (kbd "<leader>ic") #'consult-info-completion)
  ;; c coding
  (evil-define-key 'normal 'global (kbd "<leader>cl") #'my-toggle-comment)
  (evil-define-key 'normal 'global (kbd "<leader>ce") #'consult-flymake)
  (evil-mode)
  :bind (:map evil-window-map
         ;; leaving only non C versions
         ("C-h" . nil)
         ("C-j" . nil)
         ("C-k" . nil)
         ("C-l" . nil)
         ("C-q" . nil)
         ("C-o" . nil)
         )
  )

(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

(use-package doom-modeline
  ;; :requires all-the-icons
  :init
  (setq doom-modeline-major-mode-color-icon t)
  (setq doom-modeline-minor-modes t)
  (setq doom-modeline-modal t)
  (doom-modeline-mode 1)
  )

(use-package all-the-icons)

(use-package editorconfig
  :config
  (editorconfig-mode 1))

(use-package ediff
  :config
  (setq ediff-split-window-function #'split-window-horizontally))

(use-package markdown-mode
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "marked"))
