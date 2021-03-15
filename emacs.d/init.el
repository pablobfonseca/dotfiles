;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("melpa-stable" . "https://stable.melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(require 'exec-path-from-shell)
(exec-path-from-shell-initialize)

;; Change the user-emacs-directory to keep unwanted things out of ~/.emacs.d
(setq user-emacs-directory (expand-file-name "~/.cache/emacs/")
      url-history-file (expand-file-name "url/history" user-emacs-directory))

;; Use no-littering to automatically set common paths to the new user-emacs-directory
(use-package no-littering)

;; Keep customization settings in a temporary file
(setq custom-file
      (if (boundp 'server-socket-dir)
          (expand-file-name "custom.el" server-socket-dir)
        (expand-file-name (format "emacs-custom-%s.el" (user-uid)) temporary-file-directory)))
(load custom-file t)

(set-default-coding-systems 'utf-8)

(setq inhibit-startup-message t)

(scroll-bar-mode -1)              ; Disable visible scrollbar
(tool-bar-mode -1)                ; Disable the toolbar
(tooltip-mode -1)                 ; Disable the tooltips
(set-fringe-mode 10)              ; Give some breathing room
(menu-bar-mode -1)                ; Disable the menu bar
(setq ring-bell-function 'ignore) ; Ignore bell

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
  :init (load-theme 'doom-dracula t))

(set-face-attribute 'default nil :font "Fira Code" :family "Retina" :height 155)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Fira Code" :family "Retina" :height 155)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Cantarell" :height 160 :weight 'regular)

(defun personal/replace-unicode-font-mapping (block-name old-font new-font)
  (let* ((block-idx (cl-position-if
                         (lambda (i) (string-equal (car i) block-name))
                         unicode-fonts-block-font-mapping))
         (block-fonts (cadr (nth block-idx unicode-fonts-block-font-mapping)))
         (updated-block (cl-substitute new-font old-font block-fonts :test 'string-equal)))
    (setf (cdr (nth block-idx unicode-fonts-block-font-mapping))
          `(,updated-block))))

(use-package unicode-fonts
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

(use-package emojify
  :hook (erc-mode . emojify-mode)
  :commands emojify-mode)

(setq display-time-format "%l:%M %p %b %y"
      display-time-default-load-average nil)

(use-package diminish)

(use-package smart-mode-line
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

(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom (doom-modeline-height 14))

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  ;; :hook (evil-mode . personal/evil-hook)
  :config
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode-buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(evil-mode)

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package general
  :config
  (general-create-definer personal/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (personal/leader-keys
   "t" '(:ignore t :which-key "toggles")
   "tt" '(counsel-load-theme :which-key "choose theme")))

(use-package command-log-mode)

(use-package ivy
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
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-M-j" . counsel-switch-buffer)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :config
  (counsel-mode 1)
  (setq ivy-initial-inputs-alist nil)) ;; Don't start searches with ^

(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)
	 ("C-r" . swiper)))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package hydra)
(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(personal/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))

(use-package all-the-icons-dired)

(use-package dired
  :ensure nil
  :defer 1
  :commands (dired dired-jump)
  :config
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
              (hl-line-mode 1)))
  (use-package dired-rainbow
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
    :defer t)

  (use-package dired-collapse
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
      (variable-pitch-mode 1)
      (visual-line-mode 1)
      (setq org-src-tab-acts-natively t))

    (use-package org
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

      (personal/org-font-setup))

(use-package org-bullets
    :after org
    :hook (org-mode . org-bullets-mode)
    :custom
    (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun personal/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode))

(use-package visual-fill-column
  :defer t
  :hook (org-mode . personal/org-mode-visual-fill))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)))

(push '("conf-unix" . conf-unix) org-src-lang-modes)

(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))

;; Automatically tangle our Emacs.org config file when we save it
(defun personal/org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
                      (expand-file-name "~/.emacs.d/Emacs.org"))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'personal/org-babel-tangle-config)))

(defun personal/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . personal/lsp-mode-setup)
  :config
  (lsp-enable-which-key-integration t)
  :bind (:map lsp-mode-map
              ("TAB" . completion-at-point))
  :custom (lsp-headerline-breadcrumb-enable nil))

(personal/leader-keys 
  "l" '(:ignore t :which-key "lsp")
  "ld" 'xhref-find-definitions
  "lr" 'xhref-find-references
  "ln" 'lsp-ui-find-next-reference
  "lp" 'lsp-ui-find-prev-reference
  "ls" 'counsel-imenu
  "le" 'lsp-ui-flycheck-list
  "lS" 'lsp-ui-sideline-mode
  "lX" 'lsp-execute-code-action)

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :after lsp)

(use-package ruby-mode
 :mode ("\\.rb\\'" "Rakefile\\'" "Gemfile\\'")
 :hook (ruby-mode . lsp)
 :interpreter "ruby"
 :init
 (add-hook 'ruby-mode-hook (lambda () (rvm-activate-corresponding-ruby)))
 :bind (:map ruby-mode-map
       ("\C-c r r" . inf-ruby)))

(use-package inf-ruby
 :hook (ruby-mode . inf-ruby-minor-mode))

(use-package robe
 :hook (ruby-mode . robe-mode)
 :bind ("C-M-." . robe-jump)
 :config
 (defadvice inf-ruby-console-auto (before activate-rvm-for-robe activate)
  (rvm-activate-corresponding-ruby)))

(use-package nvm
  :defer t)

(use-package typescript-mode
  :mode "\\.tsx?\\'"
  :hook (typescript-mode . lsp)
  :config
  (setq typescript-indent-level 2))

(defun personal/set-js-indentation ()
  (setq js-indent-level 2)
  (setq evil-shift-width js-indent-level)
  (setq-default tab-width 2))

(use-package js2-mode
  :hook (js2-mode . lsp)
  :mode "\\.jsx?\\'"
  :config
  ;; Use js2-mode for Node scripts
  (add-to-list 'magic-mode-alist '("#!/usr/bin/env node" . js2-mode))

  ;; Don't use built-in syntax checking
  (setq js2-mode-show-strict-warnings nil)

  ;; Set up proper indentation in JavascScript and JSON files
  (add-hook 'js2-mode-hook #'personal/set-js-indentation)
  (add-hook 'json-mode-hook #'personal/set-js-indentation))

(use-package markdown-mode
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
(setq-default web-mode-code-indent-offset 2)
(setq-default web-mode-markup-indent-offset 2)
(setq-default web-mode-attribute-indent-offset 2))

;; 1. Start the server with `httpd-start`
;; 2. Use `impatient-mode` on any buffer
(use-package impatient-mode)

(use-package emmet-mode
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

(use-package flycheck
  :defer t
  :hook (lsp-mode . flycheck-mode))

(use-package yasnippet
  :hook (prog-mode . yas-minor-mode)
  :config
  (yas-reload-all))

(use-package smartparens
  :hook (prog-mode . smartparens-mode))

(use-package rainbow-mode
  :defer t
  :hook (org-mode
         emacs-lisp-mode
         web-mode
         typescript-mode
         js2-mode))

(use-package know-your-http-well
  :defer t)

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder you keep your git repos
  (when (file-directory-p "~/code")
    (setq projectile-project-search-path '("~/code")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package magit
    :custom
    (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; NOTE: Make sure to configure a GitHub token before using this package!
;; - https://magit.vc/manual/forge/Token-Creation.html#Token-Creation
;; - https://magit.vc/manual/ghub/Getting-Started.html#Getting-Started

(use-package forge)

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
