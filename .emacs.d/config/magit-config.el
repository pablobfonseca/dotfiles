;; Magit configurations

(global-set-key (kbd "C-x g") 'magit-status)
(add-hook 'magit-mode-hook (lambda() (company-mode 0)))
(global-set-key (kbd "C-c g") 'magit-file-dispatch)
