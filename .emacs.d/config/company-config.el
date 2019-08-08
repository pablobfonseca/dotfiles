;; Company Config - Autocomplete
(global-company-mode t)
(setq company-global-modes '(not org-mode))

(define-key company-mode-map (kbd "TAB") 'company-complete)
