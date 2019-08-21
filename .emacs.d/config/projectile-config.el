;; Projectile configuration
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

(setq projectile-switch-project-action #'projectile-dired)

(setq projectile-completion-system 'ivy)

;; Projectile rails
(projectile-rails-global-mode)
