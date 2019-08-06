; Configuration files

(tool-bar-mode -1)
(global-linum-mode 1)
(ido-mode 1)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)

(setq inhibit-startup-message t
      inhibit-startup-echo-area-message t)

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

;; Find recent files
(require 'recentf)

;; get rid of `find-file-read-only' and replace it with something
;; more useful.
(global-set-key (kbd "C-x C-r") 'ido-recentf-open)

;; enable recent files mode.
(recentf-mode t)

; 50 files ought to be enough.
(setq recentf-max-saved-items 50)

(defun ido-recentf-open ()
  "Use `ido-completing-read' to \\[find-file] a recent file"
  (interactive)
  (if (find-file (ido-completing-read "Find recent file: " recentf-list))
      (message "Opening file...")
    (message "Aborting")))
