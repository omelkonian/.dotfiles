;; Package repository
(require 'package)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
	 (quote
		("3b5ce826b9c9f455b7c4c8bff22c020779383a12f2f57bf2eb25139244bb7290" "2cfc1cab46c0f5bae8017d3603ea1197be4f4fff8b9750d026d19f0b9e606fae" default)))
 '(inhibit-startup-screen t)
 '(package-archives
	 (quote
		(("gnu" . "http://elpa.gnu.org/packages/")
		 ("melpa-stable" . "http://stable.melpa.org/packages/")
		 ("melpa" . "http://melpa.org/packages/")))))
(package-initialize)

;; Evil mode
(require 'evil)
    (evil-mode 1)

;; Line numbering
(global-linum-mode t)
;; No bars
(menu-bar-mode -1)
(tool-bar-mode -1)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Cua mode
(cua-mode t)
  (setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
  (transient-mark-mode 1) ;; No region when it is not highlighted
  (setq cua-keep-region-after-copy t) ;; Standard Windows behaviour

;; Agda
(load-file (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda-mode locate")))

;; Setting up Fonts for use with Agda/PLFA on DICE machines:
;;
;; default to DejaVu Sans Mono,
(set-face-attribute 'default nil
		    :family "DejaVu Sans Mono"
		    :height 120
		    :weight 'normal
		    :width  'normal)

;; fix \:
(set-fontset-font "fontset-default"
		  (cons (decode-char 'ucs #x2982)
			(decode-char 'ucs #x2982))
		  "STIX")

;; Keybindings for line indentation
(global-set-key (kbd "C->") 'indent-rigidly-right-to-tab-stop)
(global-set-key (kbd "C-<") 'indent-rigidly-left-to-tab-stop)

;; Tabs
(setq default-tab-width 2)
(setq tab-width 2)

;; Window title
(setq-default frame-title-format '("%b [%m]"))

;; Trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)
