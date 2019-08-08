;; Ruby Configuration
(add-hook 'ruby-mode-hook
	  (lambda() (rvm-activate-corresponding-ruby)))

(setq ruby-insert-encoding-magic-comment nil)
