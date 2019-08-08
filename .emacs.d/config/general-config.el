; Configuration files

(setq user-full-name "Pablo Fonseca")
(setq user-mail-address "pablofonseca777@gmail.com")

;; UTF-8 encoding
(prefer-coding-system 'utf-8)

;; Relative numbers
(setq linum-relative-mode t)

;; Highlight matching parens
(show-paren-mode 1)

;; SRGB support for OSX
(setq ns-use-srgb-colorspace t)

;; Always reload the file if it changed on disk
(global-auto-revert-mode 1)

(tool-bar-mode -1)
(global-linum-mode 1)

;; Show line and column in the mode-line
(line-number-mode 1)
(column-number-mode 1)

(setq inhibit-startup-message t
      inhibit-startup-echo-area-message t)

;; Treat underscores as words
(add-hook 'after-change-major-mode-hook
	  (lambda ()
	    (modify-syntax-entry ?_ "w")))

(add-hook 'after-change-major-mode-hook
	  (lambda ()
	    (modify-syntax-entry ?- "w")))


; Change prompt from yes/no to y/n
(fset 'yes-or-no-p 'y-or-n-p)

(setq confim-noexistent-file-or-buffer nil)
(setq ido-create-new-buffer 'always)

; Display tooltip in the echo-area
(tooltip-mode -1)
(setq tooltip-use-echo-area t)

; Kill a buffer with a process attached to it
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

;; get rid of `find-file-read-only' and replace it with something
;; more useful.
(global-set-key (kbd "C-x C-r") 'helm-recentf)

; 50 files ought to be enough.
(setq recentf-max-saved-items 50)

;; Store all backup and autosave files in the tmp dir
(defconst emacs-tmp-dir (expand-file-name (format "emacs%d" (user-uid)) temporary-file-directory))
(setq backup-directory-alist
      `((".*" . ,emacs-tmp-dir)))
(setq auto-save-file-name-transforms
      `((".*" ,emacs-tmp-dir t)))
(setq auto-save-list-file-prefix
      emacs-tmp-dir)

;; Do not create lockfiles
(setq create-lockfiles nil)

;; Which key
(setq which-key-idle-delay 0.5)

;; Multiple cursors
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; Set default browser as default OS browser
(setq browse-url-browser-function 'browse-url-default-macosx-browser)

;; For logs
(add-to-list 'auto-mode-alist '("\\.log\\'" . auto-revert-mode))

;; Set filename to the title of the window
(setq-default frame-title-format '((:eval (if (buffer-file-name)
                                              (abbreviate-file-name (buffer-file-name)) "%f"))))

;; Fix weird color escape sequences
(setq system-uses-terminfo nil)
