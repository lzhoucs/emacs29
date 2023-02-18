(defun consult-info-emacs ()
  "Search through Emacs info pages."
  (interactive)
  (consult-info "emacs" "efaq" "elisp" "cl" "compat"))

(defun consult-info-org ()
  "Search through the Org info page."
  (interactive)
  (consult-info "org"))

(defun consult-info-completion ()
  "Search through completion info pages."
  (interactive)
  (consult-info "vertico"
		"consult"
		"marginalia"
		"orderless"
		"embark"
		"corfu"
		"cape"
		"tempel"
		))

(defun my-toggle-comment ()
  "https://stackoverflow.com/a/9697222"
  (interactive)
  (let (beg end)
    (if (region-active-p)
	(setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position)))
    (comment-or-uncomment-region beg end)))


(defun my-consult-project-ripgrep()
  (interactive)
  ;; consult's approach doesn't work here, not sure why
  ;; (consult--with-project
  ;;  (consult-ripgrep)))

  ;; magit's approach works
  (consult-ripgrep (project-root (project-current t))))
