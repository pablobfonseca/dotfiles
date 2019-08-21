;; Magit configurations

(global-set-key (kbd "C-x g") 'magit-status)
(add-hook 'magit-mode-hook (lambda() (company-mode 0)))
(global-set-key (kbd "C-c g") 'magit-file-dispatch)
(magithub-feature-autoinject t)
(setq magithub-clone-default-directory "~/code")
