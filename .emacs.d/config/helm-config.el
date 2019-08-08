;; Helm configurations
(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)

(require 'helm-ls-git)
(global-set-key (kbd "C-x C-d") 'helm-browse-project)

(setq helm-mode-fuzzy-match t)
(setq helm-completion-in-region-fuzzy-match t)

(setq helm-M-x-fuzzy-match t)
(setq helm-buffers-fuzzy-matching t)
