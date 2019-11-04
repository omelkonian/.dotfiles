;; Package repository
(require 'package)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(agda-input-user-translations
	 (quote
		(("Gh" "η")
		 ("Gw" "ς")
		 ("^v" "ᵛ")
		 ("^l" "ˡ")
		 ("^r" "ʳ")
		 ("eq" "≟"))))
 '(agda2-program-args
	 (quote
		("+RTS" "-K256M" "-H3G" "-M3G" "-A128M" "-S/var/tmp/agda/AgdaRTS.log" "-RTS" "-i" ".")))
 '(company-backends
	 (quote
		(company-semantic company-capf
											(company-dabbrev-code company-gtags company-etags company-keywords)
											company-dabbrev)))
 '(coq-prog-name "/home/omelkonian/.opam/4.06.0/bin/coqtop")
 '(custom-safe-themes
	 (quote
		("0daf22a3438a9c0998c777a771f23435c12a1d8844969a28f75820dd71ff64e1" "5057614f7e14de98bbc02200e2fe827ad897696bfd222d1bcab42ad8ff313e20" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "d91ef4e714f05fff2070da7ca452980999f5361209e679ee988e3c432df24347" "1a1cdd9b407ceb299b73e4afd1b63d01bbf2e056ec47a9d95901f4198a0d2428" "170bb47b35baa3d2439f0fd26b49f4278e9a8decf611aa33a0dad1397620ddc3" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "392395ee6e6844aec5a76ca4f5c820b97119ddc5290f4e0f58b38c9748181e8d" "3b5ce826b9c9f455b7c4c8bff22c020779383a12f2f57bf2eb25139244bb7290" "2cfc1cab46c0f5bae8017d3603ea1197be4f4fff8b9750d026d19f0b9e606fae" default)))
 '(inhibit-startup-screen t)
 '(package-archives
	 (quote
		(("gnu" . "http://elpa.gnu.org/packages/")
		 ("melpa-stable" . "http://stable.melpa.org/packages/")
		 ("melpa" . "http://melpa.org/packages/"))))
 '(package-selected-packages
	 (quote
		(polymode espresso-theme leuven-theme flatui-theme spacemacs-theme solarized-theme fill-column-indicator shackle company company-coq proof-general projectile ivy haskell-mode github-theme github-modern-theme flx-ido evil)))
 '(proof-three-window-enable t)
 '(safe-local-variable-values
	 (quote
		((eval let*
					 ((Workshops-topdir
						 (expand-file-name
							(locate-dominating-file buffer-file-name ".dir-locals.el")))
						(unimath-topdir
						 (concat Workshops-topdir "UniMath/")))
					 (setq fill-column 100)
					 (make-local-variable
						(quote coq-use-project-file))
					 (setq coq-use-project-file nil)
					 (make-local-variable
						(quote coq-prog-args))
					 (setq coq-prog-args
								 (\`
									("-emacs" "-noinit" "-indices-matter" "-type-in-type" "-w" "-notation-overridden,-local-declaration,+uniform-inheritance,-deprecated-option" "-Q"
									 (\,
										(concat unimath-topdir "UniMath"))
									 "UniMath" "-R" "." "Top")))
					 (make-local-variable
						(quote coq-prog-name))
					 (setq coq-prog-name
								 (concat unimath-topdir "sub/coq/bin/coqtop"))
					 (make-local-variable
						(quote before-save-hook))
					 (add-hook
						(quote before-save-hook)
						(quote delete-trailing-whitespace))
					 (modify-syntax-entry 39 "w")
					 (modify-syntax-entry 95 "w")
					 (if
							 (not
								(memq
								 (quote agda-input)
								 features))
							 (load
								(concat unimath-topdir "emacs/agda/agda-input")))
					 (if
							 (not
								(member
								 (quote
									("chimney" "╝"))
								 agda-input-user-translations))
							 (progn
								 (setq agda-input-user-translations
											 (cons
												(quote
												 ("chimney" "╝"))
												agda-input-user-translations))
								 (setq agda-input-user-translations
											 (cons
												(quote
												 ("==>" "⟹"))
												agda-input-user-translations))
								 (agda-input-setup)))
					 (set-input-method "Agda"))))))
(package-initialize)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;;;;;;;;;;;
;; Macros ;;
;;;;;;;;;;;;
(defmacro defun-bind (fsym keyind args &rest body)
  `(progn
    (defun ,fsym ,args
      (interactive)
      ,@body)
    (global-set-key (kbd ,keyind) ',fsym)))

;;;;;;;;;;;
;; Basic ;;
;;;;;;;;;;;

;; Evil mode
(require 'evil)
(evil-mode 1)
(electric-indent-mode -1) ; disable automatic indentation
(global-unset-key (kbd "C-n"))
(global-unset-key (kbd "C-p"))
(global-unset-key (kbd "C-z"))

;; Set font
(defun set-font (height)
	(set-face-attribute 'default nil
    :family "DejaVu Sans Mono" ; "mononoki" ; Monospace ; Linux Libertine Mono O ; FreeMono
    :height height
    :weight 'normal
    :width  'normal))
(set-font 100) ; default font size

;; Save command
(defun-bind save "C-s" ()
 (save-some-buffers t))

;; Company (auto-completion)
(add-hook 'after-init-hook 'global-company-mode)

;; Sublimity (smooth scrolling)
(add-to-list 'load-path "~/.emacs.d/sublimity/")
(require 'sublimity)
(require 'sublimity-scroll)

;; Cua mode (ctrl-c, ctrl-v and friends)
(defun-bind cua/enable "C-c C-u C-a" ()
	(cua-mode t))
(cua/enable)

;; Keybindings for line indentation
(global-set-key (kbd "C->") 'indent-rigidly-right-to-tab-stop)
(global-set-key (kbd "C-<") 'indent-rigidly-left-to-tab-stop)

;; Line/column numbering (slows down Emacs...)
; (global-linum-mode t)
; (column-number-mode)

;; Color theme
; (load-theme
;  	'solarized-light t
;  	leuven
;  	espresso
;   spacemacs-light
;   flatui
;   misterioso
;  )

;; No bars
(menu-bar-mode -1)
(tool-bar-mode -1)

;; Tabs
(setq default-tab-width 2)
(setq tab-width 2)

;; Window title
(setq-default frame-title-format '("%b [%m]"))

;; Trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Keep history of mini-buffer commands
(savehist-mode 1)
(setq savehist-file "~/.emacs.d/hist.txt")

;; Buffer management
(global-set-key (kbd "M-<up>")    'windmove-up)
(global-set-key (kbd "M-<down>")  'windmove-down)
(global-set-key (kbd "M-<left>")  'windmove-left)
(global-set-key (kbd "M-<right>") 'windmove-right)

(global-set-key (kbd "C-S-k") 'windmove-up)
(global-set-key (kbd "C-S-j") 'windmove-down)
(global-set-key (kbd "C-S-h") 'windmove-left)
(global-set-key (kbd "C-S-l") 'windmove-right)

(global-set-key (kbd "C-S-e") 'split-window-right)
(global-set-key (kbd "C-S-o") 'split-window-below)
(global-set-key (kbd "C-S-w") 'delete-window)

;; Window resizing
; (global-set-key (kbd "C-A-<up>")    'enlarge-window)
; (global-set-key (kbd "C-A-<down>")  'shrink-window)
; (global-set-key (kbd "C-A-<right>") 'enlarge-window-horizontally)
; (global-set-key (kbd "C-A-<left>")  'shrink-window-horizontally)

;; Font resizing
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

;; Buffer positioning
(setq shackle-rules '(("*Async Shell Command*" :align 'below :size 0.15)
                      ("*Quail Completions*"   :size 0.2)))
(shackle-mode)

;; Keep history of recent files
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(setq recentf-max-saved-items 25)
(global-set-key (kbd "C-S-t") 'recentf-open-files)

;; Ivy (auto-completion)
;; (ivy-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Projectile (project management) ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'projectile)
(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(setq projectile-completion-system 'ivy
      projectile-enable-caching t
      projectile-project-search-path '("~/git/"))

;;;;;;;;;;;;;;;;;;;;;;
;; Agda (+ Haskell) ;;
;;;;;;;;;;;;;;;;;;;;;;

; (add-hook 'haskell-mode-hook (lambda ()
;   ...
;   ))

;; enable agda-mode
(load-file (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda-mode locate")))

(add-hook 'agda2-mode-hook (lambda ()
  ;; set interactive highlighting
  (setq agda2-highlight-level 'interactive)
  ;; set navigation keys
  (defun-bind agda/go-to-definition "C-c g" ()
    ;; Go to definition
    (agda2-goto-definition-keyboard))
  (defun-bind agda/go-back "C-c b" ()
    ;; Go to definition
    (agda2-go-back))
  (defun-bind agda/frame "C-c r" ()
    ;; Move AgdaInfo frame to the right
    (delete-other-windows)
    (split-window-right)
    (windmove-right)
    (switch-to-buffer "*Agda information*")
    (windmove-left))
  ))

;;;;;;;;;;;
;; LaTeX ;;
;;;;;;;;;;;

(defface my/title '((t (:inherit font-lock-function-name-face :height 2.0)))
  "Face used for title command in LaTeX.")
(defface my/section '((t (:inherit font-lock-function-name-face :height 1.8)))
  "Face used for section command in LaTeX.")
(defface my/subsection '((t (:inherit font-lock-function-name-face :height 1.6)))
  "Face used for subsection command in LaTeX.")
(defface my/subsubsection '((t (:inherit font-lock-function-name-face :height 1.4)))
  "Face used for subsubsection command in LaTeX.")
(defface my/paragraph '((t (:inherit font-lock-function-name-face :height 1.2)))
  "Face used for paragraph command in LaTeX.")
(defface my/site '((t (:inherit font-lock-function-name-face :foreground "DeepSkyBlue1")))
  "Face used for site command in LaTeX.")
(defface my/todo '((t (:inherit font-lock-function-name-face :foreground "tomato")))
  "Face used for TODO command in LaTeX.")
(defface my/alert '((t (:inherit font-lock-function-name-face :foreground "dark orange")))
  "Face used for TODO command in LaTeX.")

(add-hook 'latex-mode-hook (lambda ()
  ; remove keywords-3 (_ leading to suscript)
  (setq-local font-lock-defaults
	  '((tex-font-lock-keywords tex-font-lock-keywords-1 tex-font-lock-keywords-2)
	    nil nil nil nil))
 	(setq TeX-parse-self t
				TeX-save-query nil)
 	; keyboard macros
  (setq shell-command-switch "-ic")
  (defun-bind tex/build "C-c C-l" ()
    (save-buffer)
    (async-shell-command
      (concat "makeAt '" (file-name-directory buffer-file-name) "'")))
 	(defun-bind insert/textit "C-S-i" ()
 	 	(insert "\\textit{"))
 	(defun-bind insert/textbf "C-S-b" ()
 	 	(insert "\\textbf{"))
 	; (defun-bind searchSection "C-c s" ()
 	;  	(evil-search-forward)
 	;  	(execute-kbd-macro (read-kbd-macro "/ section{ RET n")))
 	; font size
 	(set-font 80)
 	; color theme
 	; (load-theme 'solarized-light t)
	; spelling
	(setq ispell-program-name "aspell"
				ispell-dictionary   "english")
	(flyspell-mode)
	(flyspell-buffer)
	; unicode input
	(require 'agda-input)
	(set-input-method "Agda") ; use C-\ to toggle-input
	; prettify symbols
	(setq prettify-symbols-alist '())
	(mapc (lambda (pair) (push pair prettify-symbols-alist))
	  '(; TeX commands
	    ("\\begin"    . "▽")
	    ("\\end"      . "△")
	    ("\\item"     . "＊")
	    ("\\par"      . "¶")
	    ("\\ref"      . "☞")
	    ("\\site"     . "🔗")
	    ("\\cite"     . "†")
	    ("\\footnote" . "‡")
	    ("\\newline"  . "⏎")
	    ("~"          . "␣")
	    ("\\textit"   . "I")
	    ("\\textbf"   . "B")
	    ))
	(font-lock-add-keywords nil
	 	'(; Basic
      ("\\\\title{\\(.*\\)}"         1 'my/title t)
      ("\\\\subtitle{\\(.*\\)}"      1 'my/section t)
	 	  ("\\\\section{\\(.*\\)}"       1 'my/section t)
	 	  ("\\\\subsection{\\(.*\\)}"    1 'my/subsection t)
	 	  ("\\\\subsubsection{\\(.*\\)}" 1 'my/subsubsection t)
	 	  ("\\\\paragraph{\\(.*\\)}"     1 'my/paragraph t)
      ; Beamer
      ("\\\\begin{frame}{\\(.*\\)}"  1 'my/section t)
      ("\\\\alert{\\(.*\\)}"         1 'my/alert t)
      ("\\\\alertblock{\\(.*\\)}"    1 'my/alert t)
      ; Custom macros
      ("\\\\site{\\(.*\\)}"          1 'my/site t)
      ("\\\\TODO{\\(.*\\)}"          1 'my/todo t)
	 	  ))
	(prettify-symbols-mode)))

;;;;;;;;;;;;;;
;; Polymode ;;
;;;;;;;;;;;;;;
(define-hostmode poly-latex-hostmode
 	:mode 'latex-mode)

(define-innermode poly-haskell-innermode
  :mode 'haskell-mode
  :head-matcher "\\\\begin{code}"
  :tail-matcher "\\\\end{code}"
  :head-mode 'host
  :tail-mode 'host)

(define-polymode poly-latex-mode
  :hostmode 'pm-host/latex
  :innermodes '(poly-haskell-innermode))

;;;;;;;;;
;; Coq ;;
;;;;;;;;;

(add-hook 'coq-mode-hook #'company-coq-mode)

(setq abbrev-expand-function #'ignore)
  ;; this is needed because company-coq's abbreviation mechanism
  ;; does not play nicely with evil mode

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Match file extensions with certain modes ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq auto-mode-alist
 	(append
 	 	'(("\\.tex\\'"      . latex-mode)
 	 	  ("\\.lhs\\'"      . latex-mode)
 	 	  ("\\.lagda\\'"    . latex-mode)
      ("\\.agda\\'"     . agda2-mode)
      ("\\.lagda.md\\'" . agda2-mode)
 	 	  )
 	 	auto-mode-alist))
