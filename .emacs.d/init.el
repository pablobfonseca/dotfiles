;;; init.el --- Pablo's Emacs configuration
;;;
;;; Copyright (c) 2019 Pablo Fonseca
;;;
;;; Author: Pablo Fonseca <pablofonseca777@gmail.com>
;;; URL: https://github.com/pablobfonseca/emacs.d

;;; Comentary:
;; My personal Emacs file

;;; Code:

(eval-when-compile
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives
               '("melpa" . "https://melpa.org/packages/") t)
  (add-to-list 'package-archives
               '("melpa-stable" . "https://stable.melpa.org/packages/") t)
  (add-to-list 'package-archives
               '("gnu" . "https://elpa.gnu.org/packages/") t)
  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package)

    (package-install 'diminish)))

;; keep the installed packages in ~/.emacs.d
(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))

(setq user-full-name "Pablo Fonseca"
      user-mail-address "pablofonseca777@gmail.com")

;; Always load newest byte code
(setq load-prefer-newer t)

;; reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76)
(setq gc-cons-threshold 50000000)

;; warn when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)

(defconst pbf-savefile-dir (expand-file-name "savefile" user-emacs-directory))

;; create the savefile dir if it doesn't exist
(unless (file-exists-p pbf-savefile-dir)
  (make-directory pbf-savefile-dir))

;; the toolbar is just a wast of valuable screen state
;; in a tty tool-bar-mode dows not properly auto-load, and is
;; already disabled anyway
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

;; disable blinking cursor
(blink-cursor-mode -1)

;; Enable line numbers globally
(global-linum-mode t)

;; disable the annoying bell ring
(setq ring-bell-function 'ignore)

;; disable startup screen
(setq inhibit-startup-screen t)

;; nice scrooling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

;; mode line settings
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

;; enable y/n answers
(fset 'yes-or-no-p 'y-or-n-p)

;; more useful frame title, that show either a file or a
;; buffer name (if the buffer isn't visiting a file)
(setq frame-title-format
      '((:eval (if (buffer-file-name)
		   (abbreviate-file-name (buffer-file-name))
		 "%b"))))

;; Indentation
(setq-default indent-tabs-mode nil)
(setq typescript-indent-level 2)

;; Wrap lines at 80 characters
(setq-default fill-column 80)

;; delete the selection with a keypress
(delete-selection-mode t)

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; revert buffers automatically when underlying fiels are changed externally
(global-auto-revert-mode t)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-locale-environment "en_US.UTF-8")
(setq process-coding-system-alist
      (cons '("grep" utf-8 . utf-8) process-coding-system-alist))

;; hippie expand is dabbrev expand on steroids
(setq hippie-expand-try-functions-list '(try-expand-dabbrev
                                         try-expand-dabbrev-all-buffers
                                         try-expand-dabbrev-from-kill
                                         try-complete-file-name-partially
                                         try-complete-file-name
                                         try-expand-all-abbrevs
                                         try-expand-list
                                         try-expand-line
                                         try-complete-lisp-symbol-partially
                                         try-complete-lisp-symbol))

;; use hippie-expand instead of dabbrev
(global-set-key (kbd "M-/") #'hippie-expand)
(global-set-key (kbd "s-/") #'hippie-expand)

;; replace buffer-menu with ibuffer
(global-set-key (kbd "C-x C-b") #'ibuffer)

;; align code in a pretty way
(global-set-key (kbd "C-x \\") #'align-regexp)

(define-key 'help-command (kbd "C-i") #'info-display-manual)

;; misc useful keybindings
(global-set-key (kbd "s-<") #'beginning-of-buffer)
(global-set-key (kbd "s->") #'end-of-buffer)
(global-set-key (kbd "s-q") #'fill-paragraph)
(global-set-key (kbd "s-x") #'execute-extended-command)

;; smart tab behavior - indent or complete
(setq tab-always-indent 'complete)

(set-face-attribute 'default nil :font "Source Code Pro 13")
(setq-default line-spacing 0)
(setq initial-frame-alist '((width . 135) (height . 55)))

;; Hide cursor in inactive windows
(setq cursor-in-non-selected-windows t)

;; Sentence should end in one space
(setq sentence-end-double-space nil)

(scroll-bar-mode -1) ;; remove scroll bar

;; Stop creating lock files
(setq create-lockfiles nil)

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

(use-package css-mode
  :config
  (setq css-indent-offset 2)
  (setq css-indent-level 2))

(use-package uniquify
  :config
  (setq uniquify-buffer-name-style 'forward)
  (setq uniquify-separator "/")
  ;; rename after killing uniquified
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
        ;; search entries
        '(search-ring regexp-search-ring)
        ;; save every minute
        savehist-autosave-interval 60
        ;; keep the home clean
        savehist-file (expand-file-name "savehist" pbf-savefile-dir))
  (savehist-mode +1))

(use-package recentf
  :config
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

  ;; enable some really cool extensions like C-x C-j (dired-jump)
  (require 'dired-x))

;;; third-party packages

(use-package restclient
  :ensure t)

(use-package evil
  :ensure t
  :config
  (evil-mode 1))

(use-package evil-matchit
  :ensure t
  :config
  (global-evil-matchit-mode 1))

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

(use-package zenburn-theme
  :ensure t
  :config
  (load-theme 'zenburn t))

(use-package simpleclip
  :ensure t
  :config
  (simpleclip-mode 1))

(use-package avy
  :ensure t
  :bind (("s-." . avy-goto-word-or-subword-1)
         ("s-," . avy-goto-char))
  :config
  (setq avy-background t))

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status))
  :config
  (setq magit-repository-directories '(("\~/code"))))

(use-package magithub
  :ensure t
  :after magit
  :config
  (magithub-feature-autoinject t)
  (setq magithub-clone-default-directory "~/code"))

(use-package git-timemachine
  :ensure t
  :bind (("s-g" . git-timemachine)))

(use-package ag
  :ensure t
  :custom
  (ag-highlight-search t)
  (ag-reuse-buffers t)
  (ag-reuse-window t))

(use-package projectile
  :ensure t
  :diminish
  :init
  (setq projectile-completion-system 'ivy)
  (setq projectile-enable-caching t)
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (projectile-mode +1)
  (projectile-rails-global-mode))

(use-package projectile-rails
  :ensure t)

(use-package helm
  :ensure t
  :config
  (require 'helm-config)
  (helm-mode)
  (helm-autoresize-mode 1)
  (setq helm-follow-mode-persistent t)
  (setq helm-M-x-fuzzy-match t)
  (setq helm-buffers-fuzzy-matching t)
  (setq helm-recentf-fuzzy-match t)
  (setq helm-apropos-fuzzy-match t)
  (setq helm-split-window-inside-p t))

(use-package helm-dash
  :ensure t
  :init
  (global-set-key (kbd "C-c d") 'helm-dash-at-point)
  (defun ruby-doc ()
    (setq helm-dash-common-docsets '("Ruby")))
  (defun rails-doc ()
    (setq helm-dash-common-docsets '("Ruby on Rails")))
  (add-hook 'ruby-mode-hook 'ruby-doc)
  (add-hook 'rails-mode-hook 'rails-doc))

(use-package helm-projectile
  :ensure t
  :config
  (helm-projectile-on))

(use-package pt
  :ensure t)

(use-package elpy
  :ensure t
  :init
  (elpy-enable)
  :config
  (setq python-shell-interpreter "/usr/local/bin/python3"))

(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

(use-package visual-regexp
  :ensure t
  :config
  (define-key global-map (kbd "s-r") 'vr/replace))

(use-package multiple-cursors
  :ensure t
  :config
  (setq mc/always-run-for-all 1)
  (global-set-key (kbd "s-d") 'mc/mark-next-like-this)
  (global-set-key (kbd "s-D") 'mc/mark-all-dwim)
  (define-key mc/keymap (kbd "<return>") nil))

(use-package anzu
  :diminish
  :ensure t
  :bind (("M-%" . anzu-query-replace)
         ("C-M-%" . anzu-query-replace-regexp))
  :config
  (global-anzu-mode))

(use-package exec-path-from-shell
  :ensure t
  :config
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)))

(use-package move-text
  :ensure t
  :bind
  (([(meta shift up)] . move-text-up)
   ([(meta shift down)] . move-text-down)))

(use-package rainbow-delimiters
  :ensure t)

(use-package rainbow-mode
  :ensure t
  :config
  (add-hook 'prog-mode-hook #'rainbow-mode))

(use-package whitespace
  :init
  (dolist (hook '(prog-mode-hook text-mode-hook))
    (add-hook hook #'whitespace-mode))
  (add-hook 'before-save-hook #'whitespace-cleanup)
  :config
  (setq whitespace-style '(face tabs trailing)))

(use-package rvm
  :ensure t)

(use-package robe
  :ensure t
  :bind ("C-M-." . robe-jump)
  :init
  (add-hook 'robe-mode-hook 'ac-robe-setup)
  (add-hook 'ruby-mode-hook 'robe-mode)

  :config
  (defadvice inf-ruby-console-auto
      (before activate-rvm-for-robe activate)
    (rvm-activate-corresponding-ruby)))

(use-package inf-ruby
  :ensure t
  :config
  (add-hook 'ruby-mode-hook #'inf-ruby-minor-mode))

(use-package ruby-mode
  :config
  (setq ruby-insert-encoding-magic-comment nil)
  (setq ruby-deep-indent-paren nil)
  (define-key ruby-mode-map (kbd "C-c C-c") 'xmp)
  (add-hook 'ruby-mode-hook #'subword-mode)
  (add-hook 'ruby-mode-hook (lambda() (rvm-activate-corresponding-ruby))))

;; rcodetools
(load-file "~/.emacs.d/config/rcodetools.el")

(use-package bundler
  :ensure t)

(use-package rspec-mode
  :ensure t
  :after ruby-mode
  :disabled t
  :init
  (progn
    (setq rspec-use-rake-flag nil))
  :config
  (progn
    (defadvice rspec-compile (around rspec-compile-around)
      "Use BASH shell for running the specs due to ZSH issues")
    (ad-activate 'rspec-compile)))

(use-package web-mode
  :ensure t
  :init
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq js-indent-level 2)
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-auto-expanding t)
  (setq web-mode-enable-css-colorization t)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-enable-auto-closing t)
  (setq web-mode-enable-current-column-highlight t)
  (setq web-mode-enable-current-element-highlight t)
  (add-hook 'web-mode-hook 'electric-pair-mode)
  :mode
  (("\\.html$\\'" . web-mode)
   ("\\.erb\\'" . web-mode)
   ("\\.mustache\\'" . web-mode)))

(use-package emmet-mode
  :ensure t
  :diminish (emmet-mode . "ε")
  :bind* (("C-)" . emmet-next-edit-point)
          ("C-(" . emmet-prev-edit-point))
  :commands (emmet-mode
             emmet-next-edit-point
             emmet-prev-edit-point)
  :init
  (setq emmet-indentation 2)
  (setq emmet-move-cursor-between-quotes t)
  :mode
  (("\\.html$\\'" . emmet-mode)
   ("\\.xml\\'" . emmet-mode)
   ("\\.erb\\'" . emmet-mode))
  :config
  ;; Auto-start on any markup modes
  (add-hook 'sgml-mode-hook 'emmet-mode)
  (add-hook 'web-mode-hook 'emmet-mode))

(use-package js2-mode
  :ensure t
  :interpreter "node"
  :mode
  (("\\.js$\\'" . js2-mode)
   ("\\.es6?\\'" . js2-mode)
   ("\\.ts?\\'" . typescript-mode))
  :config
  (setq-default js2-basic-offset 2))

(use-package indium
  :ensure t
  :after js2-mode
  :bind (:map js2-mode-map
              ("C-c C-l" . indium-eval-buffer))
  :hook (((js2-mode typescript-mode) . indium-interaction-mode)))

(use-package mocha
  :ensure t
  :after js2-mode
  :config
  (require 'typescript-mode)
  (dolist (m (list js2-mode-map typescript-mode-map))
    (bind-keys
     :map m
     ("C-c m P" . mocha-test-project)
     ("C-c m f" . mocha-test-file)
     ("C-c m p" . mocha-test-at-point))))

(use-package helm-rg
  :ensure t)

(use-package tide
  :ensure t
  :after typescript-mode
  :config
  (defun my-tide-setup-hook ()
    ;; configure tide
    (tide-setup)
    ;; highlight identifiers
    (tide-hl-identifier-mode +1)
    ;; enable eldoc-mode
    (eldoc-mode)
    ;; enable flycheck
    (flycheck-mode)

    ;; company-backends setup
    (set (make-local-variable 'company-backends)
         '((company-tide company-files :with company-yasnippet)
           (company-dabbrev-code company-dabbrev))))

  ;; add tslint checker for flycheck
  (flycheck-add-next-checker 'typescript-tide
                             'typescript-tslint)
  (setq tide-completion-detailed t)
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (javascript-mode . tide-hl-identifier-mode)))

(use-package typescript-mode
  :hook ((typescript-mode . (lambda ()
                              (my-tide-setup-hook)
                              (add-node-modules-path)
                              (company-mode))))
  :bind ((:map typescript-mode-map
               ("C-c C-t" . tide-documentation-at-point)
               ("C-c G d" . tide-jump-to-definition)
               ("C-c T p" . typescript/open-region-in-playground)))
  :config
  (defun typescript/open-region-in-playground (start end)
    "Open selected region in https://www.typescriptlang.org/Playground
                 If nothing is selected - open the whole current buffer."
    (interactive (if (use-region-p)
                     (list (region-beginning) (region-end))
                   (list (point-min) (point-max))))
    (browse-url (concat "http://www.typescriptlang.org/Playground#src="
                        (url-hexify-string (buffer-substring-no-properties start end))))))

(use-package company
  :ensure t
  :bind
  (("M-/" . hippie-expand) ;; replace `dabbrev-expand' with `hippie-expand' which does a lot more
   ("C-<tab>" . company-dabbrev))
  (:map company-active-map
        ("M-p" . nil)
        ("M-n" . nil)
        ("C-m" . nil)
        ("C-h" . nil)
        ("C-n" . company-select-next)
        ("C-p" . company-select-previous)
        ("<tab>" . company-complete-common)
        ("C-f" . company-complete-common)
        ("C-t" . company-show-doc-buffer))
  :config
  (push 'company-robe company-backends)
  (setq company-idle-delay 0)
  (setq company-echo-delay 0)
  (setq company-show-numbers t)
  (setq company-tooltip-limit 10)
  (setq company-minimum-prefix-length 1)
  (setq company-tooltip-align-annotation t)
  ;; invert the navigation direction if the completion popup-isearch-match
  ;; is displayed on top (happens near the bottom of windows)
  (setq company-tooltip-flip-when-above t)
  (company-quickhelp-mode)
  (global-company-mode))

(use-package company-quickhelp
  :ensure t
  :defines company-quickhelp-delay
  :bind (:map company-active-map
              ("M-h" . company-quickhelp-manual-begin))
  :hook (global-company-mode . company-quickhelp-mode)
  :custom
  (company-quickhelp-color-background "gray43")
  (company-quickhelp-color-foreground "selectedControlColor")
  (company-quickhelp-delay 0.5))

(use-package company-web
  :ensure t)

(use-package hl-todo
  :ensure t
  :config
  (setq hl-todo-highlight-punctuation ":")
  (global-hl-todo-mode))

(use-package imenu-anywhere
  :ensure t
  :bind (("C-c i" . imenu-anywhere)
         ("s-i" . imenu-anywhere)))

(use-package flyspell
  :diminish
  :ensure t
  :config
  (setq ispell-program-name "aspell" ; use aspell instead of ispell
        ispell-extra-args '("--sug-mode=ultra"))
  (add-hook 'text-mode-hook #'flyspell-mode)
  (add-hook 'prog-mode-hook #'flyspell-prog-mode))

(use-package flycheck
  :ensure t
  :config
  (setq-default flycheck-disabled-checkers '(ruby-rubocop))
  (add-hook 'after-init-hook #'global-flycheck-mode))

(use-package crux
  :ensure t
  :bind (("C-c o" . crux-open-with)
         ("M-o" . crux-smart-open-line)
         ("C-c n" . crux-cleanup-buffer-or-region)
         ("C-c f" . crux-recentf-find-file)
         ("C-M-z" . crux-indent-defun)
         ("C-c u" . crux-view-url)
         ("C-c e" . crux-eval-and-replace)
         ("C-c w" . crux-swap-window)
         ("C-c D" . crux-delete-file-and-buffer)
         ("C-c r" . crux-rename-buffer-and-file)
         ("C-c t" . crux-visit-term-buffer)
         ("C-c k" . crux-kill-other-buffers)
         ("C-c TAB" . crux-indent-rigidly-and-copy-to-clipboard)
         ("C-c I" . crux-find-user-init-file)
         ("C-c S" . crux-find-shell-init-file)
         ("s-r" . crux-recentf-find-file)
         ("s-j" . crux-top-join-line)
         ("C-^" . crux-top-join-line)
         ("s-k" . crux-kill-whole-line)
         ("C-<backspace>" . crux-kill-line-backwards)
         ("s-o" . crux-smart-open-line-above)
         ([remap move-beginning-of-line] . crux-move-beginning-of-line)
         ([(shift return)] . crux-smart-open-line)
         ([(control shift return)] . crux-smart-open-line)
         ([remap kill-whole-line] . crux-kill-whole-line)
         ("C-c s" . crux-ispell-word-then-abbrev)))

(use-package diff-hl
  :ensure t
  :config
  (global-diff-hl-mode +1)
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))

(use-package which-key
  :diminish
  :ensure t
  :config
  (which-key-mode +1))

(use-package undo-tree
  :ensure t
  :config
  ;; autosave the undo-tree history
  (setq undo-tree-history-directory-alist
        `((".*" . ,temporary-file-directory)))
  (setq undo-tree-auto-save-history t))

(use-package ivy
  :ensure t
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (setq enable-recursive-minibuffers t)
  (setq ivy-initial-inputs-alist nil)
  (setq ivy-re-builders-alist
        '((swiper . ivy--regex-plus)
          (swiper-isearch . ivy--regex-plus)
          (counsel-ag . ivy--regex-plus)
          (counsel-rg . ivy--regex-plus)
          (t . ivy--regex-fuzzy))) ;; enable fuzzy searching everywhere except for Swiper and ag

  (global-set-key (kbd "C-c C-r") 'ivy-resume)
  (global-set-key (kbd "<f6>") 'ivy-resume))

(use-package ace-window
  :ensure t
  :config
  (global-set-key (kbd "s-w") 'ace-window)
  (global-set-key [remap other-window] 'ace-window))

(use-package swiper
  :ensure t
  :config
  (global-set-key "\C-s" 'swiper))

(use-package counsel
  :ensure t
  :diminish ivy-mode cousel-mode
  :config
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "<f1> f") 'counsel-describe-function)
  (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
  (global-set-key (kbd "<f1> l") 'counsel-find-library)
  (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
  (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
  (global-set-key (kbd "C-c g") 'counsel-git)
  (global-set-key (kbd "C-c j") 'counsel-git-grep)
  (global-set-key (kbd "C-c a") 'counsel-rg)
  (global-set-key (kbd "C-x l") 'counsel-locate)
  ;; when using git ls (via counsel-git), include unstaged files
  (setq counsel-git-cmd "git ls-files --full-name --exclude-standard --others --cached --")
  (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history))

(use-package volatile-highlights
  :ensure t
  :config
  (volatile-highlights-mode +1))

;; config changes made through the customize UI will be stored here
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(when (file-exists-p custom-file)
  (load custom-file))

;; Fixes unsafe dir issue
(defadvice server-ensure-safe-dir (around
                                   my-around-server-ensure-safe-dir
                                   activate)
  "Ignore any errors raised from server-ensure-safe-dir."
  (ignore-errors ad-do-it))

;;; init.el ends here
