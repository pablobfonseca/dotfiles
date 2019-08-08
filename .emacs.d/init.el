;; load emacs 24's package system. Add MELPA repository.
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list 'package-archives
   '("melpa" . "http://melpa.milkbox.net/packages/")
   t))

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; Helm
(require 'helm)

;; Which Key
(require 'which-key)
(which-key-mode)

;; Evil leader mode
(require 'evil-leader)
(global-evil-leader-mode)
(evil-leader/set-leader "<SPC>")
(evil-leader/set-key
  "f" 'projectile-find-file)

;; Evil mode
(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)
(evil-mode 1)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'solarized-dark t)

(load-file "~/.emacs.d/config/general-config.el")
(load-file "~/.emacs.d/config/company-config.el")
(load-file "~/.emacs.d/config/magit-config.el")
(load-file "~/.emacs.d/config/projectile-config.el")
(load-file "~/.emacs.d/config/helm-config.el")
(load-file "~/.emacs.d/config/ruby-config.el")
(load-file "~/.emacs.d/config/webmode-config.el")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(linum-relative yasnippet-snippets yasnippet bundler markdown-mode emmet-mode company-web impatient-mode solarized-theme yaml-mode slim-mode web-mode multiple-cursors exec-path-from-shell company helm-ag evil-leader which-key projectile-ripgrep ivy rvm helm-dash helm-ls-git helm-projectile helm rspec-mode projectile-rails projectile magit dracula-theme restclient)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
