 ;; -*- lexical-binding: t; -*-

(require 'package)
(setq package-archives '(
                         ;; ("org"   . "http://orgmode.org/elpa/")
                         ("gnu"   . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

(require 'use-package)
(require 'use-package-ensure)
(setq use-package-always-ensure t)

;; Theme
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-monokai-machine t))

;; (load-file (locate-user-emacs-file "my/meow.el"))

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
  (vertico-reverse-mode)

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
  :bind (;; C-c bindings (mode-specific-map)
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ;; ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings (ctl-x-map)
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ;; ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings (goto-map)
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings (search-map)
         ("M-s d" . consult-find)
         ("M-s D" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
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
  :ensure t ; only need to install it, embark loads it after consult if found
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

  ;; The :init configuration is always executed (Not lazy!)
  :init

  ;; Must be in the :init section of use-package such that the mode gets
  ;; enabled right away. Note that this forces loading the package.
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
  (setq enable-recursive-minibuffers t))

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
         )
  :config
  (setq project-switch-commands '(
                                  (project-find-file "Find file")
                                  (magit-project-status "Magit")
                                  ))
  )
(use-package magit
  :config
  (setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  )
;; (use-package which-key
;;   :init
;;   (setq which-key-idle-delay .4)
;;   :config
;;   (which-key-mode)
;;   )

;; (use-package treesit-auto
;;   :demand t
;;   :config
;;   (add-to-list 'treesit-auto-fallback-alist '(bash-ts-mode . sh-mode))
;;   (setq treesit-auto-install 'prompt)
;;   (global-treesit-auto-mode))

;; manually map original non treesit mode to treesit mode(*-ts-mode)
;; this only works when original non treesit mode are auto loaded which isn't the case for typescript because the mode (typescript-mode) itself is not installed
;; (add-to-list 'major-mode-remap-alist '(typescript-mode . typescript-ts-mode))
;; works well
(add-to-list 'major-mode-remap-alist '(js-json-mode . json-ts-mode))
;; does not work
;; (add-to-list 'major-mode-remap-alist '(js-mode . js-ts-mode))

;; this approach works better since it doesn't require original mode to be installed
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js-ts-mode))

(add-hook 'typescript-ts-mode-hook 'eglot-ensure)
(add-hook 'js-ts-mode-hook 'eglot-ensure)


;; built in package
(use-package eglot
  :bind (:map eglot-mode-map
         ("C-c r" . eglot-rename)
         ("C-c o" . eglot-code-action-organize-imports)
         ("C-c h" . eldoc)
         ("C-c d" . xref-find-definitions)
         ("C-c t" . eglot-find-typeDefinition)
        )
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
  ;; should try and consider
  ;; evil-cross-lines
  :config
  (evil-set-leader '(normal motion visual replace operator) (kbd "SPC"))
  (evil-define-key 'normal 'global (kbd "<leader>p") project-prefix-map)
  ;; don't need it, use leader-w instead. Note because normal state reuse keys from motion state, we need to find and set it in the "root"
  (evil-define-key 'motion 'global (kbd "C-w") nil)
  (evil-define-key 'normal 'global (kbd "<leader>w") evil-window-map)
  (evil-define-key 'normal 'global (kbd "<leader>fs") #'save-buffer)
  (evil-define-key 'normal 'global (kbd "<leader>ff") #'find-file)
  (evil-define-key 'normal 'global (kbd "<leader>/") #'consult-ripgrep)
  (evil-define-key 'normal 'global (kbd "<leader>b") #'consult-buffer)
  (evil-mode)
  :bind (:map evil-window-map
         ;; leaving only non C versions
         ("C-h" . nil)
         ("C-j" . nil)
         ("C-k" . nil)
         ("C-l" . nil)
         ("C-q" . nil)
         )
  )

(use-package doom-modeline
  ;; :requires all-the-icons
  :init
  (setq doom-modeline-major-mode-color-icon t)
  (setq doom-modeline-minor-modes t)
  (setq doom-modeline-modal t)
  (doom-modeline-mode 1)
  )

(use-package all-the-icons)
