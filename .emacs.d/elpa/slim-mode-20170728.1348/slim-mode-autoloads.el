;;; slim-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "slim-mode" "slim-mode.el" (0 0 0 0))
;;; Generated autoloads from slim-mode.el

(autoload 'slim-mode "slim-mode" "\
Major mode for editing Slim files.

\\{slim-mode-map}

\(fn)" t nil)

(add-to-list 'auto-mode-alist '("\\.slim\\'" . slim-mode))

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "slim-mode" '("html-tags" "slim-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; slim-mode-autoloads.el ends here
