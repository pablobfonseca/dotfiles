;; -*- lexical-binding: t; -*-

;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

;; Profile emacs startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "*** Emacs loaded in %s seconds with %d garbage collections."
                     (emacs-init-time "%.2f")
                     gcs-done)))

;; Bootstrap straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq straight-use-package-by-default t)

;; Use straight.el for use-package expressions
(straight-use-package 'use-package)

;; Load the helper package for commands like `straight-x-clean-unused-repos'
(require 'straight-x)

(straight-use-package 'use-package)

(setq use-package-always-ensure t)

(use-package exec-path-from-shell
:straight t
  :init
  (setq exec-path-from-shell-check-startup-files nil)
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

;; Change the user-emacs-directory to keep unwanted things out of ~/.emacs.d
(setq user-emacs-directory (expand-file-name "~/.cache/emacs/")
      url-history-file (expand-file-name "url/history" user-emacs-directory))

;; Use no-littering to automatically set common paths to the new user-emacs-directory
(use-package no-littering
  :straight t)

;; Keep customization settings in a temporary file
(setq custom-file
      (if (boundp 'server-socket-dir)
          (expand-file-name "custom.el" server-socket-dir)
        (expand-file-name (format "emacs-custom-%s.el" (user-uid)) temporary-file-directory)))
(load custom-file t)

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(set-default-coding-systems 'utf-8)

(server-start)

;; Align your code in a pretty way
(global-set-key (kbd "C-x \\") 'align-regexp)

;; Font size
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

;; Window switching. (C-x o goes to the next window)
(global-set-key (kbd "C-x O") (lambda ()
                                (interactive)
                                (other-window -1))) ;; back one

;; Start vterm or switch to it if it's active
(global-set-key (kbd "C-x m") 'vterm)

;; replace buffer-menu with ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(global-set-key (kbd "C-M-u") 'universal-argument)

(defun personal/evil-hook ()
  (dolist (mode '(custom-mode
                  eshell-mode
                  git-rebase-mode
                  term-mode))
    (add-to-list 'evil-emacs-state-modes mode)))

(defun personal/dont-arrow-me-bro ()
  (interactive)
  (message "Arrow keys are bad, you know?"))

(use-package undo-tree
  :straight t
  :init
  (global-undo-tree-mode 1)
  :config
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo"))))

(use-package evil
  :straight t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-respect-visual-line-mode t)
  (setq evil-undo-system 'undo-tree)
  :hook (evil-mode . personal/evil-hook)
  :config
  (add-hook 'evil-mode-hook 'personal/evil-hook)
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode-buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal)

  ;; Define new key bindings for projectile
  (define-key evil-normal-state-map (kbd "M-p") 'projectile-switch-project)
  (define-key evil-normal-state-map (kbd "C-p") 'projectile-find-file)

  ;; Disable arrow keys in normal and visual modes
  (define-key evil-normal-state-map (kbd "<left>") 'personal/dont-arrow-me-bro)
  (define-key evil-normal-state-map (kbd "<right>") 'personal/dont-arrow-me-bro)
  (define-key evil-normal-state-map (kbd "<down>") 'personal/dont-arrow-me-bro)
  (define-key evil-normal-state-map (kbd "<up>") 'personal/dont-arrow-me-bro)

  (evil-global-set-key 'motion (kbd "<left>") 'personal/dont-arrow-me-bro)
  (evil-global-set-key 'motion (kbd "<right>") 'personal/dont-arrow-me-bro)
  (evil-global-set-key 'motion (kbd "<down>") 'personal/dont-arrow-me-bro)
  (evil-global-set-key 'motion (kbd "<up>") 'personal/dont-arrow-me-bro)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-matchit
  :straight t
  :config
  (global-evil-matchit-mode 1))

(use-package evil-collection
  :straight t
  :after evil
  :config
  (evil-collection-init)
  :custom
  (evil-collection-outline-bind-tab-p nil)
  :config
  (evil-collection-init))

;; (use-package evil-multiedit
;;   :straight t
;;   :config
;;   (define-key evil-normal-state-map (kbd "C-n") 'evil-multiedit-match-and-next)
;;   (define-key evil-visual-state-map (kbd "C-n") 'evil-multiedit-match-and-next))

(use-package multiple-cursors
  :straight t
  :config
  (define-key evil-normal-state-map (kbd "C-n") 'mc/mark-next-like-this)
  (define-key evil-visual-state-map (kbd "C-n") 'mc/mark-next-like-this))

(use-package evil-surround
  :straight t
  :config
  (global-evil-surround-mode 1))

(use-package which-key
  :straight t
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package general
  :straight t
  :config
  (general-create-definer personal/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (personal/leader-keys
    "t" '(:ignore t :which-key "toggles")
    "tw" 'whitespace-mode
    "tt" '(counsel-load-theme :which-key "choose theme")))

;; Open emacs maximized
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq inhibit-startup-message t)

(scroll-bar-mode -1)              ; Disable visible scrollbar
(tool-bar-mode -1)                ; Disable the toolbar
(tooltip-mode -1)                 ; Disable the tooltips
(set-fringe-mode 10)              ; Give some breathing room
(menu-bar-mode -1)                ; Disable the menu bar
(setq ring-bell-function 'ignore) ; Ignore bell
(setq display-line-numbers-type 'relative) ; Relative line numbers

;; nice scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

;; remap scroll-other-window
(global-set-key (kbd "C-M-e") 'scroll-other-window)
(global-set-key (kbd "C-M-y") 'scroll-other-window-down)

;; enable y/n answers
(fset 'yes-or-no-p 'y-or-n-p)

;; Highlight current line
(global-hl-line-mode 1)

(column-number-mode)

;; Enable line numbers for some modes
(dolist (mode '(text-mode-hook
                prog-mode-hook
                conf-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 1))))

;; Override some modes which derive from the above
(dolist (mode '(org-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(setq large-file-warning-threshold nil)

(setq vc-follow-symlinks t)

(use-package doom-themes
  :straight t
  :defer t
  :init (load-theme 'doom-dracula t))

(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font" :family "Regular" :height 190)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "JetBrainsMono Nerd Font" :family "Regular" :height 190)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Cantarell" :height 190 :weight 'normal)

(defun personal/replace-unicode-font-mapping (block-name old-font new-font)
  (let* ((block-idx (cl-position-if
                         (lambda (i) (string-equal (car i) block-name))
                         unicode-fonts-block-font-mapping))
         (block-fonts (cadr (nth block-idx unicode-fonts-block-font-mapping)))
         (updated-block (cl-substitute new-font old-font block-fonts :test 'string-equal)))
    (setf (cdr (nth block-idx unicode-fonts-block-font-mapping))
          `(,updated-block))))

(use-package unicode-fonts
  :straight t
  :custom
  (unicode-fonts-skip-font-groups '(low-quality-glyphs))
  :config
  ;; Fix the font mappings to use the right emoji font
  (mapcar
    (lambda (block-name)
      (personal/replace-unicode-font-mapping block-name "Apple Color Emoji" "Noto Color Emoji"))
    '("Dingbats"
      "Emoticons"
      "Miscellaneous Symbols and Pictographs"
      "Transport and Map Symbols"))
  (unicode-fonts-setup))

;; Enable emoji, and stop the UI from freezing when trying to display them
(when (fboundp 'set-fontset-font)
  (set-fontset-font t 'unicode "Apple Color Emoji" nil 'prepend))

(use-package emojify
  :straight t
  :hook (erc-mode . emojify-mode)
  :commands emojify-mode)

(setq display-time-format "%l:%M %p %b %y"
      display-time-default-load-average nil)

(use-package diminish
  :straight t)

(use-package smart-mode-line
  :straight t
  :disabled
  :config
  (setq sml/no-confirm-load-theme t)
  (sml/setup)
  (sml/apply-theme 'respectful)  ; Respect the theme colors
  (setq sml/mode-width 'right
        sml/name-width 60)

  (setq-default mode-line-format
                `("%e"
                  ,(when personal/exwm-enabled
                     '(:eval (format "[%d] " exwm-workspace-current-index)))
                  mode-line-front-space
                  evil-mode-line-tag
                  mode-line-mule-info
                  mode-line-client
                  mode-line-modified
                  mode-line-remote
                  mode-line-frame-identification
                  mode-line-buffer-identification
                  sml/pos-id-separator
                  (vc-mode vc-mode)
                  " "
                                        ;mode-line-position
                  sml/pre-modes-separator
                  mode-line-modes
                  " "
                  mode-line-misc-info))

  (setq rm-excluded-modes
        (mapconcat
         'identity
                                        ; These names must start with a space!
         '(" GitGutter" " MRev" " company"
           " Helm" " Undo-Tree" " Projectile.*" " Z" " Ind"
           " Org-Agenda.*" " ElDoc" " SP/s" " cider.*")
         "\\|")))

;; You must run (all-the-icons-install-fonts) one time after
;; installing the package!

(use-package all-the-icons
  :straight t)

(use-package doom-modeline
  :straight t
  :init (doom-modeline-mode 1)
  :custom (doom-modeline-height 14))

(global-auto-revert-mode 1)

(use-package paren
  :straight t
  :config
  (set-face-attribute 'show-paren-match-expression nil :background "#363e4a")
  (show-paren-mode 1))

(setq-default tab-width 2)
(setq-default evil-shift-width tab-width)

;; hippie expand is dabbrev expand on steroids
(setq hippie-expand-try-functions-list '(try-expand-dabbrev
                                         try-expand-dabbrev-all-buffers
                                         try-expand-dabbrev-from-kill
                                         try-complete-file-name-partially
                                         try-complete-file-name
                                         try-expand-all-abbrevs
                                         try-expand-list
                                         try-expand-line
                                         try-complete-listp-symbol-partially
                                         try-complete-listp-symbol))

(setq-default indent-tabs-mode nil)

(use-package evil-nerd-commenter
  :straight t
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

(use-package ws-butler
  :straight t
  :hook ((text-mode . ws-butler-mode)
         (prog-mode . ws-butler-mode)))

(use-package editorconfig
  :straight t
  :ensure t
  :config
  (editorconfig-mode 1))

(use-package origami
  :straight t)

(use-package expand-region
  :straight t
  :bind ("C-=" . er/expand-region))

(use-package dotcrafter
  :straight '(dotcrafter :host github
                         :repo "daviwil/dotcrafter.el"
                         :branch "main")
  :custom
  (dotcrafter-dotfiles-folder "~/.emacs.d")
  (dotcrafter-org-files '("Emacs.org")))

(defun personal/org-file-jump-to-heading (org-file heading-title)
  (interactive)
  (find-file (expand-file-name org-file))
  (goto-char (point-min))
  (search-forward (concat "* " heading-title))
  (org-overview)
  (org-reveal)
  (org-show-subtree)
  (forward-line))

(defun personal/org-file-show-headings (org-file)
  (interactive)
  (find-file (expand-file-name org-file))
  (counsel-org-goto)
  (org-overview)
  (org-reveal)
  (org-show-subtree)
  (forward-line))

(personal/leader-keys
  "f"  '(:ignore t :which-key "dotfiles")
  "fe" '((lambda () (interactive) (find-file "~/.emacs.d/Emacs.org")) :which-key "edit config")
  "fz" '((lambda () (interactive) (find-file "~/.dotfiles/Zsh.org")) :which-key "edit zsh config")
  "fv" '((lambda () (interactive) (find-file "~/.dotfiles/Vim.org")) :which-key "edit vim config"))

(use-package command-log-mode
  :straight t)

(use-package helpful
  :straight t
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package hydra
  :straight t
  :defer 1)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(personal/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))

(use-package ivy
  :straight t
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :init
  (ivy-mode 1)
  :config
  (setq ivy-use-virtual-buffers t)
  (setq ivy-wrap t)
  (setq ivy-count-format "(%d/%d) ")
  (setq enable-recursive-minibuffers t)

  ;; Use different regex strategies per completion command
  (push '(completion-at-point . ivy--regex-fuzzy) ivy-re-builders-alist)
  (push '(swiper . ivy--regex-ignore-order) ivy-re-builders-alist)
  (push '(counsel-M-x . ivy--regex-ignore-order) ivy-re-builders-alist)


  ;; Set minibuffer heght for different commands
  (setf (alist-get 'swiper ivy-height-alist) 15)
  (setf (alist-get 'counsel-switch-buffer ivy-height-alist) 7))

(use-package ivy-rich
  :straight t
  :init
  (ivy-rich-mode 1)
  :after counsel
  :config
  (setq ivy-format-function #'ivy-format-function-line)
  (setq ivy-rich-display-transformers-list
        (plist-put ivy-rich-display-transformers-list
                   'ivy-switch-buffer
                   '(:columns
                     ((ivy-rich-candidate (:width 40))
                      (ivy-rich-switch-buffer-indicators (:width 4 :face error :align right)); return the buffer indicators
                      (ivy-rich-switch-buffer-major-mode (:width 12 :face warning))          ; return the major mode info
                      (ivy-rich-switch-buffer-project (:width 15 :face success))             ; return project name using `projectile'
                      (ivy-rich-switch-buffer-path (:width (lambda (x) (ivy-rich-switch-buffer-shorten-path x (ivy-rich-minibuffer-width 0.3))))))))))  ; return file path relative to project root or `default-directory' if project is nil

(use-package counsel
  :straight t
  :bind (("M-x" . counsel-M-x)
         ("C-M-j" . counsel-switch-buffer)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         ("C-M-l" . counsel-imenu)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :config
  (counsel-mode 1)
  (setq ivy-initial-inputs-alist nil)) ;; Don't start searches with ^

;; Improves sorting for fuzzy-matched results
(use-package flx
  :straight t
  :after ivy
  :defer t
  :init
  (setq ivy-flx-limit 10000))

(use-package wgrep
  :straight t)

(use-package ivy-posframe
  :straight t
  :disabled
  :custom
  (ivy-posframe-width 115)
  (ivy-posframe-min-width 115)
  (ivy-posframe-height 10)
  :config
  (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-center)))
  (setq ivy-posframe-parameters '((parent-frame . nil)
                                  (left-fringe . 8)
                                  (right-fringe . 8)))
  (ivy-posframe-mode 1))

(personal/leader-keys
  "r" '(ivy-resume :which-key "ivy resume")
  "f" '(:ignore t :which-key "files")
  "ff" '(counsel-find-file :which-key "open file")
  "C-f" 'counsel-find-file
  "fr" '(counsel-recentf :which-key "recent files")
  "fR" '(revert-buffer :which-key "revert file")
  "fj" '(counsel-file-jump :which-key "jump to file"))

(use-package swiper
  :straight t
  :after ivy
  :bind (("C-s" . swiper)
         ("C-r" . swiper)))

(use-package avy
  :straight t
  :commands (avy-goto-char avy-goto-word-0 avy-goto-line))

(personal/leader-keys
  "j" '(:ignore t :which-key "jump")
  "jj" '(avy-goto-char :which-key "jump to char")
  "jw" '(avy-goto-word-0 :which-key "jump to word")
  "jl" '(avy-goto-line :which-key "jump to line"))

(use-package default-text-scale
  :straight t
  :defer 1
  :config
  (default-text-scale-mode))

(use-package ace-window
  :straight t
  :bind (("M-o" . ace-window))
  :custom
  (aw-scope 'frame)
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  (aw-minibuffer-flag t)
  :config
  (ace-window-display-mode 1))

(use-package transpose-frame
  :straight t)

(defun personal/org-mode-visual-fill ()
  (setq visual-fill-column-width 110
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :straight t
  :defer t
  :hook (org-mode . personal/org-mode-visual-fill))

(use-package all-the-icons-dired
  :straight t)

(use-package dired
  :ensure nil
  :straight nil
  :defer 1
  :commands (dired dired-jump)
  :config
  (when (string= system-type "darwin")
    (setq dired-use-ls-dired nil))
  (setq dired-omit-files "^\\.[^.].*"
        dired-omit-verbose nil
        dired-hide-details-hide-symlinks-targets nil)

  (autoload 'dired-omit-mode "dired-x")

  (add-hook 'dired-load-hook
            (lambda ()
              (interactive)
              (dired-collapse)))

  (add-hook 'dired-mode-hook
            (lambda ()
              (interactive)
              (dired-omit-mode 1)
              (dired-hide-details-mode 1)
              (all-the-icons-dired-mode 1)
              (hl-line-mode 1)))

  (use-package dired-rainbow
    :straight t
    :defer 2
    :config
    (dired-rainbow-define-chmod directory "#6cb2eb" "d.*")
    (dired-rainbow-define html "#eb5286" ("css" "less" "sass" "scss" "htm" "html" "jhtm" "mht" "eml" "mustache" "xhtml"))
    (dired-rainbow-define xml "#f2d024" ("xml" "xsd" "xsl" "xslt" "wsdl" "bib" "json" "msg" "pgn" "rss" "yaml" "yml" "rdata"))
    (dired-rainbow-define document "#9561e2" ("docm" "doc" "docx" "odb" "odt" "pdb" "pdf" "ps" "rtf" "djvu" "epub" "odp" "ppt" "pptx"))
    (dired-rainbow-define markdown "#ffed4a" ("org" "etx" "info" "markdown" "md" "mkd" "nfo" "pod" "rst" "tex" "textfile" "txt"))
    (dired-rainbow-define database "#6574cd" ("xlsx" "xls" "csv" "accdb" "db" "mdb" "sqlite" "nc"))
    (dired-rainbow-define media "#de751f" ("mp3" "mp4" "mkv" "MP3" "MP4" "avi" "mpeg" "mpg" "flv" "ogg" "mov" "mid" "midi" "wav" "aiff" "flac"))
    (dired-rainbow-define image "#f66d9b" ("tiff" "tif" "cdr" "gif" "ico" "jpeg" "jpg" "png" "psd" "eps" "svg"))
    (dired-rainbow-define log "#c17d11" ("log"))
    (dired-rainbow-define shell "#f6993f" ("awk" "bash" "bat" "sed" "sh" "zsh" "vim"))
    (dired-rainbow-define interpreted "#38c172" ("py" "ipynb" "rb" "pl" "t" "msql" "mysql" "pgsql" "sql" "r" "clj" "cljs" "scala" "js"))
    (dired-rainbow-define compiled "#4dc0b5" ("asm" "cl" "lisp" "el" "c" "h" "c++" "h++" "hpp" "hxx" "m" "cc" "cs" "cp" "cpp" "go" "f" "for" "ftn" "f90" "f95" "f03" "f08" "s" "rs" "hi" "hs" "pyc" ".java"))
    (dired-rainbow-define executable "#8cc4ff" ("exe" "msi"))
    (dired-rainbow-define compressed "#51d88a" ("7z" "zip" "bz2" "tgz" "txz" "gz" "xz" "z" "Z" "jar" "war" "ear" "rar" "sar" "xpi" "apk" "xz" "tar"))
    (dired-rainbow-define packaged "#faad63" ("deb" "rpm" "apk" "jad" "jar" "cab" "pak" "pk3" "vdf" "vpk" "bsp"))
    (dired-rainbow-define encrypted "#ffed4a" ("gpg" "pgp" "asc" "bfe" "enc" "signature" "sig" "p12" "pem"))
    (dired-rainbow-define fonts "#6cb2eb" ("afm" "fon" "fnt" "pfb" "pfm" "ttf" "otf"))
    (dired-rainbow-define partition "#e3342f" ("dmg" "iso" "bin" "nrg" "qcow" "toast" "vcd" "vmdk" "bak"))
    (dired-rainbow-define vc "#0074d9" ("git" "gitignore" "gitattributes" "gitmodules"))
    (dired-rainbow-define-chmod executable-unix "#38c172" "-.*x.*"))

  (use-package dired-single
    :straight t
    :defer t)

  (use-package dired-collapse
    :straight t
    :defer t))

(defun personal/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.1)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(defun personal/org-mode-setup ()
  (org-indent-mode)
  (flyspell-mode)
  (visual-line-mode 1)
  (setq org-src-tab-acts-natively t))

(use-package org
  :straight f
  :hook (org-mode . personal/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")

  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)

  (setq org-hide-emphasis-markers t)
  (setq org-agenda-files
        '("~/Dropbox/Study/Emacs/OrgFiles/Tasks.org"
          "~/Dropbox/Study/Emacs/OrgFiles/Habit.org"
          "~/Dropbox/Study/Emacs/OrgFiles/Birthdays.org"))

  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 60)

  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
          (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(@a/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))

  (setq org-refile-targets
        '(("Archive.org" :maxlevel . 1)
          ("Tasks.org" :maxlevel . 1)))

  ;; Save Org buffers after refiling!
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  (setq org-tag-alist
        '((:startgroup)
                                        ; Put mutually exclusive tags here
          (:endgroup)
          ("@errand" . ?E)
          ("@home" . ?H)
          ("@work" . ?W)
          ("agenda" . ?a)
          ("planning" . ?p)
          ("publish" . ?P)
          ("batch" . ?b)
          ("note" . ?n)
          ("idea" . ?i)
          ("thinking" . ?t)
          ("recurring" . ?r)))

  ;; Configure custom agenda views
  (setq org-agenda-custom-commands
        '(("d" "Dashboard"
           ((agenda "" ((org-deadline-warning-days 7)))
            (todo "NEXT"
                  ((org-agenda-overriding-header "Next Tasks")))
            (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

          ("n" "Next Tasks"
           ((todo "NEXT"
                  ((org-agenda-overriding-header "Next Tasks")))))

          ("W" "Work Tasks" tags-todo "+work-email")

          ;; Low-effort next actions
          ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
           ((org-agenda-overriding-header "Low Effort Tasks")
            (org-agenda-max-todos 20)
            (org-agenda-files org-agenda-files)))

          ("w" "Workflow Status"
           ((todo "WAIT"
                  ((org-agenda-overriding-header "Waiting on External")
                   (org-agenda-files org-agenda-files)))
            (todo "REVIEW"
                  ((org-agenda-overriding-header "In Review")
                   (org-agenda-files org-agenda-files)))
            (todo "PLAN"
                  ((org-agenda-overriding-header "In Planning")
                   (org-agenda-todo-list-sublevels nil)
                   (org-agenda-files org-agenda-files)))
            (todo "BACKLOG"
                  ((org-agenda-overriding-header "Project Backlog")
                   (org-agenda-todo-list-sublevels nil)
                   (org-agenda-files org-agenda-files)))
            (todo "READY"
                  ((org-agenda-overriding-header "Ready for Work")
                   (org-agenda-files org-agenda-files)))
            (todo "ACTIVE"
                  ((org-agenda-overriding-header "Active Projects")
                   (org-agenda-files org-agenda-files)))
            (todo "COMPLETED"
                  ((org-agenda-overriding-header "Completed Projects")
                   (org-agenda-files org-agenda-files)))
            (todo "CANC"
                  ((org-agenda-overriding-header "Cancelled Projects")
                   (org-agenda-files org-agenda-files)))))))

  (setq org-capture-templates
        `(("t" "Tasks / Projects")
          ("tt" "Task" entry (file+olp "~/Dropbox/Study/Emacs/OrgFiles/Tasks.org" "Inbox")
           "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)

          ("j" "Journal Entries")
          ("jj" "Journal" entry
           (file+olp+datetree "~/Dropbox/Study/Emacs/OrgFiles/Journal.org")
           "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
           :clock-in :clock-resume
           :empty-lines 1)
          ("jm" "Meeting" entry
           (file+olp+datetree "~/Dropbox/Study/Emacs/OrgFiles/Journal.org")
           "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
           :clock-in :clock-resume
           :empty-lines 1)

          ("w" "Workflows")
          ("we" "Checking Email" entry (file+olp+datetree "~/Dropbox/Study/Emacs/OrgFiles/Journal.org")
           "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)

          ("m" "Metrics Capture")
          ("mw" "Weight" table-line (file+headline "~/Dropbox/Study/Emacs/OrgFiles/Metrics.org" "Weight")
           "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t)))

  (define-key global-map (kbd "C-c c")
    (lambda () (interactive) (org-capture)))

  (personal/org-font-setup)

(use-package org-bullets
  :straight t
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (shell . t)
   (python . t)))

(push '("conf-unix" . conf-unix) org-src-lang-modes)

(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))
(add-to-list 'org-structure-template-alist '("yaml" . "src yaml"))
(add-to-list 'org-structure-template-alist '("json" . "src json"))
(add-to-list 'org-structure-template-alist '("js" . "src javascript"))
(add-to-list 'org-structure-template-alist '("lua" . "src lua"))
(add-to-list 'org-structure-template-alist '("ruby" . "src ruby"))
(add-to-list 'org-structure-template-alist '("vimrc" . "src vimrc"))

;; Since we don't want to disable org-confirm-babel-evaluate all
;; of the time, do it around the after-save-hook
(defun personal/org-babel-tangle-dont-ask ()
  ;; Dynamic scoping to the rescue
  (let ((org-confirm-babel-evaluate nil))
    (org-babel-tangle)))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'personal/org-babel-tangle-dont-ask
                                              'run-at-end 'only-in-org-mode)))

(fset 'evil-redirect-digit-argument 'ignore) ;; before evil-org loaded

(add-to-list 'evil-digit-bound-motions 'evil-org-beginning-of-line)
(evil-define-key 'motion 'evil-org-mode
  (kbd "0") 'evil-org-beginning-of-line)

(use-package evil-org
  :straight t
  :after org
  :hook ((org-mode . evil-org-mode)
         (org-agenda-mode . evil-org-mode)
         (evil-org-mode . (lambda () (evil-org-set-key-theme '(navigation todo insert textobjects additional)))))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(personal/leader-keys
  "o" '(:ignore t :which-key "org mode")
  "oi" '(:ignore t :which-key "insert")
  "oil" '(org-insert-link :which-key "insert link")
  "on" '(org-toggle-narrow-to-subtree :which-key "toggle narrow")
  "oa" '(org-agenda :which-key "status")
  "ot" '(org-todo-list :which-key "todos")
  "oc" '(org-capture t :which-key "capture")
  "ox" '(org-export-dispatch t :which-key "export")))

(use-package tree-sitter
  :straight t
  :config
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package tree-sitter-langs
  :straight t
  :after tree-sitter)

(use-package apheleia
  :straight t
  :config
  (apheleia-global-mode +1))

(defvar *compile-command-map* '(("py" . "python")
                                ("go" . "go run")
                                ("rb" . "ruby")
                                ("js" . "node")))

(defun ~run-current-file (f command-map)
  "Run command map with function f
  f can be: compile, ~acme$, ~acme&, ~acme!"
  (interactive)
  (save-buffer)

  (let* ((fname (s-chop-suffix (car (s-match "<.*>" (buffer-name))) (buffer-name)))
         (suffix (file-name-extension fname))
         (prog (cdr (assoc suffix command-map))))
    (if (null prog)
        (error "Extension is not yet registered")
      (funcall f (format "%s %s" prog (shell-quote-argument fname))))))

(defun ~compile-current-file ()
  "(re)compile the current file. A replacement for compile with automatic filetype recognition.
                              e.g. If the current buffer is hello.py, then it'll call python hello.py"
  (interactive)
  (save-buffer)
  (~run-current-file 'compile *compile-command-map*))

;; default compile command to empty string
(setq compile-command "")

(defun ~recompile ()
  "custom recompile "
  (interactive)
  (save-buffer)
  (recompile))

(defvar *test-command-map* '(("py" . "pytest -s -v")
                             ("go" . "go test")))

(defun ~test-current-file ()
  "Test current file using 'compile'. Automatic filetype recogntion.
    e.g. If the current buffer is hello.py, then it'll call pytest hello.py
    "
  (interactive)
  (~run-current-file 'compile *test-command-map*))

(personal/leader-keys
  "c" '(:ignore t :which-key "compile")
  "cc" '(~compile-current-file :which-key "compile current file")
  "ct" '(~test-current-file :which-key "test current file"))

(use-package magit
  :straight t
  :bind ("C-M-;" . magit-status)
  :commands (magit-status)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(personal/leader-keys
  "g" '(:ignore t :which-key "git")
  "gs" 'magit-status
  "gd" 'magit-diff-unstaged
  "gc" 'magit-branch-or-checkout
  "gl" '(:ignore t :which-key "log")
  "glc" 'magit-log-current
  "glf" 'magit-log-buffer-file
  "gb" 'magit-branch
  "gP" 'magit-push-current
  "gp" 'magit-pull-branch
  "gf" 'magit-fetch
  "gF" 'magit-fetch-all
  "gr" 'magit-rebase)

;; NOTE: Make sure to configure a GitHub token before using this package!
;; - https://magit.vc/manual/forge/Token-Creation.html#Token-Creation
;; - https://magit.vc/manual/ghub/Getting-Started.html#Getting-Started

(use-package forge
  :straight t)

(use-package magit-todos
  :straight t
  :defer t)

(use-package git-link
  :straight t
  :commands git-link
  :config
  (setq git-link-open-in-browser t)
  (personal/leader-keys
    "gL" 'git-link))

(use-package git-gutter
  :straight git-gutter-fringe
  :diminish
  :hook ((text-mode . git-gutter-mode)
         (prog-mode . git-gutter-mode))
  :config
  (setq git-gutter:update-interval 2)
  (require 'git-gutter-fringe)
  (set-face-foreground 'git-gutter-fr:added "LightGreen")
  (fringe-helper-define 'git-gutter-fr:added nil
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    ".........."
    ".........."
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    ".........."
    ".........."
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX")

  (set-face-foreground 'git-gutter-fr:modified "LightGoldenrod")
  (fringe-helper-define 'git-gutter-fr:modified nil
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    ".........."
    ".........."
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    ".........."
    ".........."
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX")

  (set-face-foreground 'git-gutter-fr:deleted "LightCoral")
  (fringe-helper-define 'git-gutter-fr:deleted nil
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    ".........."
    ".........."
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    ".........."
    ".........."
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX")

  ;; These characters are used in terminal mode
  (setq git-gutter:modified-sign "≡")
  (setq git-gutter:added-sign "≡")
  (setq git-gutter:deleted-sign "≡")
  (set-face-foreground 'git-gutter:added "LightGreen")
  (set-face-foreground 'git-gutter:modified "LightGoldenrod")
  (set-face-foreground 'git-gutter:deleted "LightCoral"))

(defun personal/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :straight t
  :commands lsp
  :hook (lsp-mode . personal/lsp-mode-setup)
  :config
  (define-key evil-normal-state-map (kbd ",ra") 'lsp-rename)

  (lsp-enable-which-key-integration t)
  :bind (:map lsp-mode-map
              ("TAB" . completion-at-point))
  :custom (lsp-headerline-breadcrumb-enable nil))

(personal/leader-keys
  "l" '(:ignore t :which-key "lsp")
  "ld" 'lsp-find-definition
  "lr" 'lsp-find-references
  "ln" 'lsp-ui-find-next-reference
  "lp" 'lsp-ui-find-prev-reference
  "ls" 'counsel-imenu
  "le" 'lsp-ui-flycheck-list
  "lS" 'lsp-ui-sideline-mode
  "lx" 'lsp-execute-code-action)

(use-package lsp-ui
  :straight t
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (define-key evil-normal-state-map (kbd "H") 'lsp-ui-doc-glance)
  (setq lsp-ui-doc-position 'at-point))

(use-package eglot
  :straight t)

(use-package ruby-mode
  :mode ("\\.rb\\'" "Rakefile\\'" "Gemfile\\'")
  :hook (ruby-mode . lsp)
  :interpreter "ruby"
  :config
  (setq ruby-insert-encoding-magic-comment nil)
  (add-hook 'ruby-mode-hook (lambda () (rvm-activate-corresponding-ruby)))
  :bind (:map ruby-mode-map
              ("\C-c r r" . inf-ruby)))

(use-package bundler
  :straight t)
(use-package rvm
  :straight t)

(use-package inf-ruby
  :straight t
  :hook (ruby-mode . inf-ruby-minor-mode))

(use-package rbs-mode
  :straight t)

(use-package robe
  :straight t
  :hook (ruby-mode . robe-mode)
  :bind ("C-M-." . robe-jump)
  :config
  (defadvice inf-ruby-console-auto (before activate-rvm-for-robe activate)
    (rvm-activate-corresponding-ruby)))

(use-package rubocop
  :straight t)

(use-package rspec-mode
  :straight t
  :after ruby-mode
  :init
  (progn
    (setq rspec-use-spring-when-possible nil)
    (setq rspec-use-rake-flag nil))
  :config
  (setq rspec-use-rvm t)
  (add-hook 'after-init-hook 'inf-ruby-switch-setup))

(use-package python-mode
  :straight t
  :hook (python-mode . lsp))

(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp))))  ; or lsp-deferred

(use-package pyvenv
  :straight t
  :hook (python-mode . pyvenv-mode))

(use-package nvm
  :straight t)

(use-package typescript-mode
  :after tree-sitter
  :mode (("\\.tsx?\\'" . typescript-mode)
         ("\\.tsx\\'" . rjsx-mode))
  :hook (typescript-mode . lsp)
  :config
  (define-derived-mode typescriptreact-mode typescript-mode
    "TypeScript TSX")

  ;; use our derived mode for tsx files
  (add-to-list 'auto-mode-alist '("\\.tsx?\\'" . typescriptreact-mode))
  ;; by default, typescript-mode is mapped to the treesitter typescript parser
  ;; use our derived mode to map both .tsx AND .ts -> typescriptreact-mode -> treesitter tsx
  (add-to-list 'tree-sitter-major-mode-language-alist '(typescriptreact-mode . tsx))
  (setq typescript-indent-level 2))

(defun personal/set-js-indentation ()
  ;; electric-layout-mode doesn't play nice with smartparens
  (setq-local electrict-layout-rules '((?\{ . around) (?\} . around)))
  (setq js-indent-level 2)
  (setq evil-shift-width js-indent-level)
  (setq-default tab-width 2))

(use-package js2-mode
  :straight t
  :hook (js2-mode . lsp)
  :mode "\\.jsx?\\'"
  :config
  ;; Use js2-mode for Node scripts
  (add-to-list 'magic-mode-alist '("#!/usr/bin/env node" . js2-mode))

  ;; Don't use built-in syntax checking
  (setq js2-mode-show-strict-warnings nil)

  ;; Set up proper indentation in JavascScript and JSON files
  (add-hook 'js2-mode-hook #'personal/set-js-indentation))

(use-package json-mode
  :straight t
  :config
  (add-hook 'json-mode-hook #'personal/set-js-indentation))

(use-package indium
  :straight t)

(use-package markdown-mode
  :straight t
  :mode "\\.md\\'"
  :config
  (setq markdown-command "marked")
  (defun personal/set-markdown-header-font-sizes ()
    (dolist (face '((markdown-header-face-1 . 1.2)
                    (markdown-header-face-2 . 1.1)
                    (markdown-header-face-3 . 1.0)
                    (markdown-header-face-4 . 1.0)
                    (markdown-header-face-5 . 1.0)))
      (set-face-attribute (car face) nil :weight 'normal :height (cdr face))))
      (defun personal/markdown-mode-hook ()
        (personal/set-markdown-header-font-sizes))
  (add-hook 'markdown-mode-hook 'personal/markdown-mode-hook))

(use-package web-mode
  :mode "(\\.\\(html?\\|ejs\\|tsx\\|jsx\\)\\'"
  :config
  (setq web-mode-enable-auto-pairing nil)
  (setq-default web-mode-code-indent-offset 2)
  (setq-default web-mode-css-indent-offset 2)
  (setq-default web-mode-markup-indent-offset 2)
  (setq web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'")))
  (setq-default web-mode-attr-indent-offset 2))

;; 1. Start the server with `httpd-start`
;; 2. Use `impatient-mode` on any buffer
(use-package impatient-mode
  :straight t)

(use-package css-mode
  :hook (css-mode . lsp)
  :config
  (setq-default css-indent-offset 2))

(use-package haml-mode
  :straight t)

(use-package emmet-mode
  :straight t
  :diminish (emmet-mode . "ε")
  :bind* (("C-)" . emmet-next-edit-point)
          ("C-(" . emmet-prev-edit-point))
  :commands (emmet-mode
             emmet-next-edit-point
             emmet-prev-edit-point)
  :custom
  (emmet-indentation 2)
  (emmet-move-cursor-between-quotes t)
  :mode
  (("\\.html$\\'" . emmet-mode)
   ("\\.xml\\'" . emmet-mode)
   ("\\.erb\\'" . emmet-mode))
  :init
  ;; Auto-start on any markup modes
  (add-hook 'sgml-mode-hook 'emmet-mode)
  (add-hook 'web-mode-hook 'emmet-mode))

(use-package yaml-mode
  :mode "\\.ya?ml\\'")

(defun personal/go-mode-defaults ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t)
  (add-hook 'go-mode-hook #'lsp-deferred)
  (define-key 'help-command (kbd "G") 'godoc)

  (setq tab-width 4)
  (setq evil-shift-width tab-width)

  ;; Prefer goimports to gofmt if installed
  (let ((goimports (executable-find "goimports")))
    (when goimports
      (setq gofmt-command goimports)))

  ;; gofmt on save
  (add-hook 'before-save-hook 'gofmt-before-save nil t))

(use-package go-mode
  :straight t
  :defer t
  :hook (go-mode . lsp)
  :config
  (add-hook 'go-mode-hook #'personal/go-mode-defaults))

(use-package rust-mode
  :straight t
  :hook (rust-mode . lsp)
  :mode "\\.rs\\'"
  :init (setq rust-format-on-save t))

(use-package cargo
  :straight t
  :defer t)

(use-package lsp-haskell
  :straight t
  :defer t)

(use-package haskell-mode
  :straight t
  :config
  (add-hook 'haskell-mode-hook #'lsp)
  (add-hook 'haskell-literate-mode-hook #'lsp))

(use-package elm-mode
  :straight t
  :config
  (setq elm-format-on-save t))

(use-package caml
  :straight t)

(use-package tuareg
  :hook (tuareg-mode . lsp)
  :mode ("\\.ml[ily]?$" . tuareg-mode)
  :straight t)

;; (use-package merlin
;;   :straight t
;;   :custom
;;   (merlin-completion-with-doc t)
;;   :bind (:map merlin-mode-map
;;               ("M-." . merlin-locate)
;;               ("M-," . merlin-pop-stack)
;;               ("M-?" . merlin-occurrences)
;;               ("C-c C-j" . merlin-jump)
;;               ("C-c i" . merlin-locate-ident)
;;               ("C-c C-e" . merlin-iedit-occurrences))
;;   :hook
;;   ;; Start merlin on ml files
;;   ((reason-mode tuareg-mode caml-mode) . merlin-mode))

(use-package utop
  :custom
  (utop-edit-command nil)
  :hook
  (tuareg-mode . (lambda ()
                   (setq utop-command "utop -emacs")
                   (utop-minor-mode)))
  (reason-mode . (lambda ()
                   (setq utop-command "rtop -emacs")
                   (setq utop-prompt
                         (lambda ()
                           (let ((prompt (format "rtop[%d]> " utop-command-number)))
                             (add-text-properties 0 (lenght prompt) '(face utop-prompt) prompt)
                             prompt)))
                   (utop-minor-mode)))
  :straight t)

(defun shell-cmd (cmd)
  "Returns the stdout output of a shell command or nil if the command returned an error"
  (car (ignore-errors (apply 'process-lines (split-string cmd)))))

(setq opam-p (shell-cmd "which opam"))
(setq reason-p (shell-cmd "which refmt"))

(use-package reason-mode
  :straight t
  :if reason-p
  :config
  (add-hook 'reason-mode-hook (lambda ()
                                (add-hook 'before-save-hook #'refmt-before-save)))
  (let* ((refmt-bin (or (shell-cmd "refmt ----where")
                        (shell-cmd "which refmt")))
         (merlin-bin (or (shell-cmd "ocamlerlin ----where")
                         (shell-cmd "which ocamlmerlin")))
         (merlin-base-dir (when merlin-bin
                            (replace-regexp-in-string "bin/ocamlmerlin$" "" merlin-bin))))
    ;; Add npm merlin.el to the emacs load path and tell emacs where to find ocamlerlin
    (when merlin-bin
      (add-to-list 'load-path (concat merlin-base-dir "share/emacs/site-lisp/"))
      (setq merlin-command merlin-bin))
    (when refmt-bin
      (setq refmt-command refmt-bin)))
  )

(use-package vimrc-mode
  :straight t)

(use-package lua-mode
  :straight t)

(use-package s
  :straight (:host github :repo "magnars/s.el");; :files ("s.el"))
  :ensure t)

(use-package dash
  :straight (:host github :repo "magnars/dash.el");; :files ("dash.el"))
  :ensure t)

(use-package copilot
  :straight (:host github :repo "zerolfx/copilot.el" :files ("dist" "*.el"))
  :bind (:map copilot-completion-map
              ("M-l" . 'copilot-accept-completion)
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))

(dolist (mode '(prog-mode-hook
                org-mode-hook))
  (add-hook mode 'copilot-mode))

(use-package flycheck
  :straight t
  :defer t
  :hook (lsp-mode . flycheck-mode))

(use-package yasnippet
  :straight t
  :hook (prog-mode . yas-minor-mode)
  :config
  (yas-reload-all))

(use-package smartparens
  :straight t
  :hook (prog-mode . smartparens-mode))

(use-package rainbow-mode
  :straight t
  :defer t
  :hook (org-mode
         emacs-lisp-mode
         web-mode
         typescript-mode
         js2-mode))

(use-package company
  :straight t
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :straight t
  :hook (company-mode . company-box-mode))

(use-package projectile
  :straight t
  :diminish projectile-mode
  :bind
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder you keep your git repos
  (when (file-directory-p "~/code")
    (setq projectile-project-search-path '("~/code"))))
  ;; (setq projectile-switch-project-action #'projectile-dired))

(use-package rainbow-delimiters
  :straight t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package restclient
  :straight t
  :mode ("\\.http\\'" . restclient-mode))

(use-package term
  :straight t
  :config
  (setq explicit-shell-file-name "zsh"))

(use-package eterm-256color
  :straight t
  :hook (term-mode . eterm-256color-mode))

(use-package vterm
  :straight t
  :commands vterm
  :config
  (setq vterm-max-scrollback 10000))

(defun personal/configure-eshell()
  ;; Save command history when commands are entered
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

  ;; Truncate buffer for performace
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

  ;; Bind some useful keys for evil-mode
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "C-r") 'counsel-esh-history)
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "<home>") 'eshell-bol)
  (evil-normalize-keymaps)

  (setq eshell-history-size         10000
        eshell-buffer-maximum-lines 10000
        eshell-hist-ignoredups t
        eshell-scroll-to-bottom-on-input t))

(use-package eshell-git-prompt
  :straight t)

(use-package eshell
  :hook (eshell-first-time-mode . personal/configure-eshell)
  :config
  (eshell-git-prompt-use-theme 'powerline))

(use-package eshell-toggle
  :straight t
  :bind ("C-x C-t" . eshell-toggle)
  :custom
  (eshell-toggle-size-fraction 3)
  (eshell-toggle-use-project-root t)
  (eshell-toggle-run-command nil))

(use-package docker
  :straight t
  :commands docker)

(use-package dockerfile-mode
  :straight t
  :config
  (require 'dockerfile-mode)
  (add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode)))

(use-package ripgrep
  :straight t)

(use-package deadgrep
  :straight t)

(use-package crux
  :straight t)
