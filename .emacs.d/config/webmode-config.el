;; Webmode config
(setq web-mode-content-type-alist '(("jsx" . "\\.tsx\\'")))
(setq web-mode-content-type-alist '(("jsx" . "\\.js\\'")))

(add-to-list 'auto-mode-alist '("\\.erb?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.js?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.ts?\\'" . web-mode))

;; Js2-mode
(add-to-list 'auto-mode-alist '("\\.js?\\'" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.ts?\\'" . js2-mode))

(setq web-mode-enable-auto-closing t)

(setq web-mode-enable-current-column-highlight t)
(setq web-mode-enable-current-element-highlight t)

(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
	(set (make-local-variable 'company-backends) '(company-css company-web-html company-yasnippet company-files))
  )

(add-hook 'web-mode-hook 'my-web-mode-hook)
(setq tab-width 2)
