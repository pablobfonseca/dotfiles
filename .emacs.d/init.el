(require 'package)

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
;; keep the installed packages in .emacs.d
(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))
(package-initialize)

;; update the package metadata if the local cache is missing
(unless package-archive-contents
		(package-refresh-contents))

(setq user-full-name "Pablo Fonseca"
		user-mail-address "pablofonseca777@gmail.com")

;; Always load newest byte code
(setq load-prefer-newer t)

;; reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 50000000)

;; warn when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)

(defconst pbf-savefile-dir (expand-file-name "savefile" user-emacs-directory))

;; create the savefile dir if it doesn't exist
(unless (file-exists-p pbf-savefile-dir)
		(make-directory pbf-savefile-dir))

;; remove toolbar
(when (fboundp 'tool-bar-mode)
	(tool-bar-mode -1))

;; nice scrolling
(setq scroll-margin 0
			scroll-conservatively 100000
			scroll-preserve-screen-position 1)

;; mode line settings
(line-number-mode 1)
(linum-relative-global-mode 1)
(column-number-mode t)
(size-indication-mode t)

;; enable y/n answers
(fset 'yes-or-no-p 'y-or-n-p)

;; Set filename to the title of the window
(setq frame-title-format
'((:eval (if (buffer-file-name)
						 (abbreviate-file-name (buffer-file-name))
					 "%b"))))

;; Set tab to 2 spaces
(setq-default tab-width 2)

;; Wrap lines at 80 characters
(setq-default fill-column 80)

;; Store all backup and autosave files in the tmp dir
(defconst emacs-tmp-dir (expand-file-name (format "emacs%d" (user-uid)) temporary-file-directory))
(setq backup-directory-alist
      `((".*" . ,emacs-tmp-dir)))
(setq auto-save-file-name-transforms
      `((".*" ,emacs-tmp-dir t)))
(setq auto-save-list-file-prefix
      emacs-tmp-dir)

;; revert buffers automatically when underlying files are changed externally
(global-auto-revert-mode t)

;; utf-8 encoding
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; replace buffer-menu with ibuffer
(global-set-key (kbd "C-x C-b") #'ibuffer)

;; align code in a pretty way
(global-set-key (kbd "C-x \\") #'align-regexp)

(define-key 'help-command (kbd "C-i") #'info-display-manual)

;; smart tab behavior - indend or complete
(setq tab-always-indent 'complete)

;; Disable startup message
(setq inhibit-startup-message t
      inhibit-startup-echo-area-message t)

;; SRGB support for OSX
(setq ns-use-srgb-colorspace t)

;; Kill a buffer with a process attached to it
(setq kill-buffer-query-functions
      (remq 'process-kill-buffer-query-function
	    kill-buffer-query-functions))

; Visual indication instead of the ringbell(setq ring-bell-function
(setq ring-bell-function
      (lambda ()
	(let ((orig-fg (face-foreground 'mode-line)))
	  (set-face-foreground 'mode-line "#F2804F")
	  (run-with-idle-timer 0.1 nil
			       (lambda (fg) (set-face-foreground 'mode-line fg))
			       orig-fg))))

;; Do not create lockfiles
(setq create-lockfiles nil)

;; Set default browser as default OS browser
(setq browse-url-browser-function 'browse-url-default-macosx-browser)

;; Fix weird color escape sequences
(setq system-uses-terminfo nil)

(unless (package-installed-p 'use-package)
	(package-install 'use-package))

(require 'use-package)
(setq use-package-verbose t)

;;; built-in packages
(use-package paren
	:config
	(show-paren-mode +1))

(use-package elec-pair
	:config
	(electric-pair-mode +1))

;; highlight the current line
(use-package hl-line
	:config
	(global-hl-line-mode +1))

(use-package abbrev
	:config
	(setq save-abbrevs 'silently)
	(setq-default abbrev-mode t))

(use-package uniquify
	:config
	(setq uniquify-buffer-name-style 'forward)
	(setq uniquify-separator "/")
	;;rename after killing uniquified
	(setq uniquify-after-kill-buffer-p t)
	;; don't muck with special buffers
	(setq uniquify-ignore-buffers-re "^\\*"))

;; saveplace remembers your location in a file when saving files
(use-package saveplace
	:config
	(setq save-place-file (expand-file-name "saveplace" pbf-savefile-dir))
	;; activate it for all buffers
	(setq-default save-place t))

(use-package savehist
	:config
	(setq savehist-additional-variables
				;; search entried
				'(search-ring regexp-search-ring)
				;; save every minute
				savehist-autosave-interval 60
				;; keep the home clean
				savehist-file (expand-file-name "savehist" pbf-savefile-dir))
	(savehist-mode +1))

(use-package recentf
	:config
	(global-set-key (kbd "C-x C-r") 'helm-recentf)
	(setq recentf-save-file (expand-file-name "recentf" pbf-savefile-dir)
				recentf-max-saved-items 500
				recentf-max-menu-items 15
				;; disable recentf-cleanup on Emacs start, because it can cause
				;; problems with remote files
				recentf-auto-cleanup 'never)
	(recentf-mode +1))

(use-package windmove
	:config
	;; use shift + arrow keys to switch between visible buffers
	(windmove-default-keybindings))

(use-package dired
	:config
	;; dired - reuse current buffer by pressing 'a'
	(put 'dired-find-alternate-file 'disabled nil)

	;; always delete and copy recursively
	(setq dired-recursive-deletes 'always)
	(setq dired-recursive-copies 'always)

	;; if there is a dired buffer displayed in the next window, use its
	;; current subdir, instead of the current subdir of this dired buffer
	(setq dired-dwim-target t)

	;; enable some really cool extensions like C-x C-j(dired-jump)
	(require 'dired-x))

(use-package magit
	:ensure t
	:config
	(add-hook 'magit-mode-hook (lambda() (company-mode 0)))
	:bind (("C-x g" . magit-status)
				 ("C-c g" . magit-file-dispatch)))

(use-package magithub
	:after magit
	:config
	(magithub-feature-autoinject t)
	(setq magithub-clone-default-directory "~/code"))

(use-package projectile
	:ensure t
	:init
	(setq projectile-completion-system 'ivy)
	(setq projectile-switch-project-action #'projectile-dired)
	:config
	(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
	(projectile-mode +1)
	(projectile-rails-global-mode))

(use-package exec-path-from-shell
	:ensure t
	:config
	(when (memq window-system '(mac ns x))
		(exec-path-from-shell-initialize)))

(use-package whitespace
	:init
	(dolist (hook '(prog-mode-hook text-mode-hook))
		(add-hook hook #'whitespace-mode))
	(add-hook 'before-save-hook #'whitespace-cleanup)
	:config
	(setq whitespace-line-column 80) ;; limit line length
	(setq whitespace-style '(face tabs empty trailing lines-tail)))

(use-package inf-ruby
	:ensure t
	:config
	(add-hook 'ruby-mode-hook #'inf-ruby-minor-mode))

;; rcodetools
(load-file "~/.emacs.d/config/rcodetools.el")

(use-package ruby-mode
	:config
	(setq ruby-insert-encoding-magic-comment nil)
	(define-key ruby-mode-map (kbd "C-c C-c") 'xmp)
	(add-hook 'ruby-mode-hook #'subword-mode)
	(add-hook 'ruby-mode-hook (lambda() (rvm-activate-corresponding-ruby))))

(use-package rspec-mode
	:ensure t
	:after ruby-mode
	:disabled t
	:init
	(progn
		(setq rspec-use-rake-flag nil))
	:config
	(progn
		(defadvice rspec-compile (around rspec-compile-around activate)
			"Use BASH shell for running the specs because of ZSH issues."
			(let ((shell-file-name "/bin/bash"))
				ad-do-it))))


(use-package haskell-mode
	:ensure t
	:config
	(add-hook 'haskell-mode-hook #'subword-mode)
	(add-hook 'haskell-mode-hook #'interactive-haskell-mode)
	(add-hook 'haskell-mode-hook #'haskell-doc-mode))

(use-package markdown-mode
	:ensure t
	:mode (("\\.md\\'" . gfm-mode)
				 ("\\.markdown\\'" . gfm-mode))
	:config
	(setq markdown-fontify-code-blocks-natively t))

(use-package yaml-mode
	:ensure t)

(use-package company
	:ensure t
	:config
	(setq company-global-modes '(not-org-mode))
	(setq company-idle-delay 0.5)
	(setq company-show-number t)
	(setq company-tooltip-limit 10)
	(setq company-minimum-prefix-length 2)
	(setq company-tooltip-align-annotations t)
	;; invert the navigation direction if the completion popup-isearch-match
	;; is displayed on top (happens near the bottom of windows)
	(setq company-tooltip-flip-when-above t)
	(global-company-mode))


(use-package hl-todo
	:ensure t
	:config
	(setq hl-todo-highlight-punctuation ":")
	(global-hl-todo-mode))

(use-package flyspell
	:config
	(setq ispell-program-name "aspell" ; use aspell instead of ispell
				ispell-extra-args '("--sug-mode=ultra"))
	(add-hook 'text-mode-hook #'flyspell-mode)
	(add-hook 'prog-mode-hook #'flyspell-prog-mode))

(use-package which-key
	:ensure t
	:config
	(which-key-mode +1)
	(setq which-key-idle-delay 0.5))

(use-package ivy
	:ensure t
	:config
	(ivy-mode 1)
	(setq ivy-use-virtual-buffers t)
	(setq enable-recursive-minibuffers t)
	(global-set-key (kbd "C-c C-r") 'ivy-resume)
	(global-set-key (kbd "<f6>") 'ivy-resume))

(use-package counsel
	:ensure t
	:config
	(global-set-key (kbd "M-x") 'counsel-M-x)
	(global-set-key (kbd "C-x C-f") 'counsel-find-file)
	(global-set-key (kbd "C-c C-g") 'counsel-git)
	(global-set-key (kbd "C-c j") 'counsel-git-grep)
	(global-set-key (kbd "C-c a") 'counsel-ag)
	(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history))

(use-package helm
	:ensure t
	:bind
	(("C-x C-d" . helm-browse-project))
	:config
	(setq helm-mode-fuzzy-match t)
	(setq helm-completion-in-region-fuzzy-match t)
	(setq helm-M-x-fuzzy-match t)
	(setq helm-buffers-fuzzy-matching t)
	(helm-mode 1))

(use-package helm-ls-git
	:ensure t)

;; Evil mode
(use-package evil
	:config
	(evil-mode 1))

(use-package multiple-cursors
	:config
	(global-set-key (kbd "C->") 'mc/mark-next-like-this)
	(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
	(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this))

(use-package evil-matchit
	:config
	(global-evil-matchit-mode 1))

(use-package evil-surround
	:config
	(global-evil-surround-mode 1))

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'distinguished t)

(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
	(set (make-local-variable 'company-backends) '(company-css company-web-html company-files))
  )

(use-package web-mode
	:ensure t
	:init
	(add-hook 'web-mode-hook 'my-web-mode-hook)
	:mode
	(("\\.erb\\'" . web-mode)
	 ("\\.mustache\\'" . web-mode)
	 ("\\.html?\\'" . web-mode))
	:config
	(setq web-mode-enable-auto-closing t)
	(setq web-mode-enable-current-column-highlight t)
	(setq web-mode-enable-current-element-highlight t))

(use-package emmet-mode
	:ensure t
	:commands emmet-mode
	:init
	(setq emmet-indentation 2)
	(setq emmet-move-cursor-between-quotes t)
	:config
	(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto start on any markup modes
	(add-hook 'css-mode-hook 'emmet-mode) ;; enable Emmet's css abbreviation
	)

(use-package js2-mode
	:ensure t
	:interpreter "node"
	:mode
	(("\\.js?\\'" . js2-mode)
	 ("\\.ts?\\'" . js2-mode)))

(defun go-mode-setup ()
	(setq compile-command "go build -v && go test -v && go vet")
	(define-key (current-local-map) "\C-c\C-c" 'compile)
	(go-eldoc-setup)
	(setq gofmt-command "goimports")
	(add-hook 'before-save-hook 'gofmt-before-save))

(use-package go-mode
	:init
	(add-hook 'go-mode-hook 'go-mode-setup))

;; config changes made through the customize UI will be stored here
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(when (file-exists-p custom-file)
	(load custom-file))
