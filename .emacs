;; Package repository
(require 'package)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(agda-input-user-translations
   '(("Gh" "η")
     ("Gw" "ς")
     ("^v" "ᵛ")
     ("^l" "ˡ")
     ("^r" "ʳ")
     ("_v" "ᵥ")
     ("eq" "≟")
     ("bx" "𝕩")
     ("z;" "⨟")
     ("rn" "И")
     ("rg" "⅁")
     ("({" "｛")
     (")}" "｝")
     (".." "·")
     ("check" "✓")
     ("cross" "✖")))
 '(agda2-backend "GHC")
 '(agda2-program-args
   '("+RTS" "-K40M" "-H1G" "-M24G" "-A128M" "-S/var/tmp/agda/AgdaRTS.log" "-RTS" "-i" "." "--latex-dir=."))
 '(agda2-program-name "agda")
 '(company-backends '(company-dabbrev))
 '(company-dabbrev-downcase nil)
 '(coq-prog-name "/home/omelkonian/.opam/4.05.0/bin/coqtop")
 '(custom-safe-themes
   '("0daf22a3438a9c0998c777a771f23435c12a1d8844969a28f75820dd71ff64e1" "5057614f7e14de98bbc02200e2fe827ad897696bfd222d1bcab42ad8ff313e20" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "d91ef4e714f05fff2070da7ca452980999f5361209e679ee988e3c432df24347" "1a1cdd9b407ceb299b73e4afd1b63d01bbf2e056ec47a9d95901f4198a0d2428" "170bb47b35baa3d2439f0fd26b49f4278e9a8decf611aa33a0dad1397620ddc3" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "392395ee6e6844aec5a76ca4f5c820b97119ddc5290f4e0f58b38c9748181e8d" "3b5ce826b9c9f455b7c4c8bff22c020779383a12f2f57bf2eb25139244bb7290" "2cfc1cab46c0f5bae8017d3603ea1197be4f4fff8b9750d026d19f0b9e606fae" default))
 '(idris-interpreter-path "idris2")
 '(ignored-local-variable-values '((TeX-engine . xetex)))
 '(inhibit-startup-screen t)
 '(package-archives
   '(("gnu" . "http://elpa.gnu.org/packages/")
     ("melpa-stable" . "http://stable.melpa.org/packages/")
     ("melpa" . "http://melpa.org/packages/")))
 '(package-selected-packages
   '(outline-magic idris-mode docker-tramp magit dash lsp-haskell lsp-ui lsp-mode yafolding origami counsel markdown-mode helm-make gnu-elpa-keyring-update org-projectile-helm polymode espresso-theme leuven-theme flatui-theme spacemacs-theme solarized-theme fill-column-indicator shackle company company-coq proof-general projectile ivy haskell-mode github-theme github-modern-theme flx-ido evil))
 '(proof-three-window-enable t)
 '(safe-local-variable-values
   '((TeX-master . t)
     (eval let*
	   ((Workshops-topdir
	     (expand-file-name
	      (locate-dominating-file buffer-file-name ".dir-locals.el")))
	    (unimath-topdir
	     (concat Workshops-topdir "UniMath/")))
	   (setq fill-column 100)
	   (make-local-variable 'coq-use-project-file)
	   (setq coq-use-project-file nil)
	   (make-local-variable 'coq-prog-args)
	   (setq coq-prog-args
		 `("-emacs" "-noinit" "-indices-matter" "-type-in-type" "-w" "-notation-overridden,-local-declaration,+uniform-inheritance,-deprecated-option" "-Q" ,(concat unimath-topdir "UniMath")
		   "UniMath" "-R" "." "Top"))
	   (make-local-variable 'coq-prog-name)
	   (setq coq-prog-name
		 (concat unimath-topdir "sub/coq/bin/coqtop"))
	   (make-local-variable 'before-save-hook)
	   (add-hook 'before-save-hook 'delete-trailing-whitespace)
	   (modify-syntax-entry 39 "w")
	   (modify-syntax-entry 95 "w")
	   (if
	       (not
		(memq 'agda-input features))
	       (load
		(concat unimath-topdir "emacs/agda/agda-input")))
	   (if
	       (not
		(member
		 '("chimney" "╝")
		 agda-input-user-translations))
	       (progn
		 (setq agda-input-user-translations
		       (cons
			'("chimney" "╝")
			agda-input-user-translations))
		 (setq agda-input-user-translations
		       (cons
			'("==>" "⟹")
			agda-input-user-translations))
		 (agda-input-setup)))
	   (set-input-method "Agda"))))
 '(warning-suppress-log-types '((comp))))
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
(defmacro def-interactive (fsym args &rest body)
  `(progn
    (defun ,fsym ,args
      (interactive)
      ,@body)))

(defmacro def-bind (fsym keyind args &rest body)
  `(progn
    (defun ,fsym ,args
      (interactive)
      ,@body)
    (global-set-key (kbd ,keyind) ',fsym)))

;;;;;;;;;;;
;; Basic ;;
;;;;;;;;;;;

(def-interactive reload-emacs ()
  (load-file user-init-file))

;; Get access to $PATH
(exec-path-from-shell-initialize)

;; Evil mode
(require 'evil)
(evil-mode 1)
(electric-indent-mode -1) ; disable automatic indentation
(global-unset-key (kbd "C-n"))
(global-unset-key (kbd "C-p"))
(global-unset-key (kbd "C-z"))


;; Set font
(defun set-font-family (font bfont height)
  (setq family font)
  (setq fallback bfont)
  (set-face-attribute 'default nil
    :family family
    :height height
    :weight 'normal
    :width  'normal)
  (dolist (ft (fontset-list))
    (set-fontset-font ft 'unicode (font-spec :name family))
    (set-fontset-font ft 'unicode (font-spec :name fallback) nil 'append)))
(defun set-font (height)
  (set-font-family
    ; MAIN FONT ;
    ; "DejaVu Sans Mono"
    ; "mononoki"
    ; "Asanb Math monospacified for DejaVu Sans Mono"
    ; "Everson Mono Bold"
    "Julia Mono"
    ; BACKUP FONT ;
    "DejaVu Sans Mono"
    height))
; default font size
(set-font
  ; 80
  ; 90
  ; 100
  120
  )

;; Save command
(def-bind save "C-s" ()
  (save-some-buffers t))

;; Spawn new Emacs instance command
(def-bind spawnEmacs "C-S-n" ()
  (call-process "sh" nil nil nil "-c" "emacs &"))

;; YASnippet
(require 'yasnippet)
(yas-global-mode 1)
; (add-hook 'prog-mode-hook #'yas-minor-mode)
(setq yas-snippet-dir "~/.emacs.d/snippets")

;; Company (auto-completion)
(add-hook 'after-init-hook 'global-company-mode)

;; Ivy (auto-completion)
; (ivy-mode 1)

;; Sublimity (smooth scrolling)
(add-to-list 'load-path "~/.emacs.d/sublimity/")
(require 'sublimity)
(require 'sublimity-scroll)

;; automatically wrap lines
; (add-hook 'text-mode-hook 'turn-on-auto-fill)

;; Cua mode (ctrl-c, ctrl-v and friends)
; (def-bind cua/enable "C-c C-u C-a" ()
;   (cua-mode t))
; (cua/enable)

;; Keybindings for line indentation
(global-set-key (kbd "C->") 'indent-rigidly-right-to-tab-stop)
(global-set-key (kbd "C-<") 'indent-rigidly-left-to-tab-stop)

;; Line/column numbering (slows down Emacs...)
(if (version<= "26.0.50" emacs-version)
  (global-display-line-numbers-mode)
  (global-linum-mode))
(column-number-mode)

;; Vertical column rule
; (setq fci-rule-column 80)
; (fci-mode)
(defun rule-hook ()
  (display-fill-column-indicator-mode)
  (setq display-fill-column-indicator-column 85))
(add-hook 'prog-mode-hook 'rule-hook)
(add-hook 'text-mode-hook 'rule-hook)

;; Color theme
; (load-theme
;   'solarized-light t
;   leuven
;   espresso
;   spacemacs-light
;   flatui
;   misterioso
;  )
(set-face-attribute 'region nil :background "#fff3e6") ; #ffe6cc ; #ffdab3 ; #ffce99

;; No bars
(menu-bar-mode -1)
(tool-bar-mode -1)

;; Tabs
(setq indent-tabs-mode nil)
(setq default-tab-width 2)
(setq tab-width 2)
(setq evil-shift-width 4)

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
(require 'windsize)
; (windsize-default-keybindings)
(global-set-key (kbd "C-M-<left>")  'windsize-left)
(global-set-key (kbd "C-M-<right>") 'windsize-right)
(global-set-key (kbd "C-M-<up>")    'windsize-up)
(global-set-key (kbd "C-M-<down>")  'windsize-down)
; (evil-define-key 'normal emacs-windsize-map (kbd "C-S-<left>") 'windsize-left)

;; Font resizing
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

;; Buffer positioning
(setq shackle-rules '(("*Async Shell Command*" :align 'below :size 0.15)
                      ("*Quail Completions*"   :size 0.2)
                      ("*compilation*"         :size 0.2)))
(shackle-mode)

;; Keep history of recent files
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(setq recentf-max-saved-items 25)
(global-set-key (kbd "C-S-t") 'recentf-open-files)

;; Folding (indentation-based, e.g. for Haskell & Agda)

; (require 'origami)
(require 'yafolding)

(global-set-key (kbd "s-d y") 'yafolding-discover)

(add-hook 'prog-mode-hook  (lambda () (yafolding-mode)))
(add-hook 'latex-mode-hook (lambda () (yafolding-mode)))

(define-key yafolding-mode-map (kbd "<C-S-return>") 'yafolding-hide-parent-element)
(define-key yafolding-mode-map (kbd "<C-M-return>") 'yafolding-toggle-all)
(define-key yafolding-mode-map (kbd "<C-return>") 'yafolding-toggle-element)

;; Folding (outline-based, e.g. for TeX environments)
(add-to-list 'load-path "~/.emacs.d/packages/")
(eval-after-load 'outline
  '(progn
    (require 'outline-magic)
    (define-key outline-minor-mode-map (kbd "<C-tab>") 'outline-cycle)))
(add-hook 'prog-mode-hook #'outline-minor-mode)
(add-hook 'latex-mode-hook #'outline-minor-mode)

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

;;;;;;;;;;;;;
;; Haskell ;;
;;;;;;;;;;;;;

(add-hook 'haskell-mode-hook #'lsp)
(add-hook 'haskell-literate-mode-hook #'lsp)

;;;;;;;;;;
;; Agda ;;
;;;;;;;;;;

;; Set custom GHC environment
; (setenv "GHC_ENVIRONMENT" "agda")

;; enable agda-mode
(load-file (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda-mode locate")))

;; enable agda-input everywhere ; use C-\ to toggle-input
(require 'agda-input)
(set-input-method "Agda")

(def-bind agda/setTexBackend "C-c t" ()
  (setq agda2-backend "QuickLaTeX"))
  ; (setq agda2-program-args (append agda2-program-args '("--latex-dir" "."))))

;; Makefiles

(defun makeFile ()
  "Call `make dir/filename` at the closest Makefile."
  (interactive)
  (async-shell-command
    (concat "makeAt '" (file-name-directory buffer-file-name) "'"
                  " '" (file-name-base buffer-file-name) "'")))

(def-interactive agda/make ()
  (agda/setTexBackend)
  (agda2-compile)
  (makeFile))
(def-interactive tex/make ()
  (save-buffer)
  (makeFile))
(def-interactive agda/makeParent ()
  (agda/setTexBackend)
  (agda2-compile)
  (async-shell-command "makeParent"))
(def-interactive tex/makeParent ()
  (save-buffer)
  (async-shell-command "makeParent"))

(def-bind make "C-c l" ()
  (setq ext (file-name-extension buffer-file-name))
  (cond
    ((string= ext "tex")   (tex/make))
    ((string= ext "lagda") (agda/make))
    ))

(def-bind makeParent "C-c m" ()
  (setq ext (file-name-extension buffer-file-name))
  (cond
    ((string= ext "tex")   (tex/makeParent))
    ((string= ext "lagda") (agda/makeParent))
    ))

(add-hook 'agda2-mode-hook (lambda ()
  ;; set interactive highlighting
  (setq agda2-highlight-level 'interactive)
  (def-bind agda/run "C-c C-x C-x" ()
    ;; run compiled GHC file
    (save-buffer)
    (async-shell-command (concat "./" (file-name-base buffer-file-name))))
  ;   (save-buffer)
  ;   (async-shell-command
  ;     (concat "\./" (file-name-base buffer-file-name))))
  ;   (agda2-goto-definition-keyboard))
  ;; set navigation keys
  (def-bind agda/go-to-definition "C-c g" ()
    ;; Go to definition
    (agda2-goto-definition-keyboard))
  (def-bind agda/go-back "C-c b" ()
    ;; Go to definition
    (agda2-go-back))
  (def-bind agda/frame "C-c r" ()
    ;; Move AgdaInfo frame to the right
    (delete-other-windows)
    (split-window-right)
    (windmove-right)
    (switch-to-buffer "*Agda information*")
    (windmove-left))
  (def-bind agda/compileTex "C-c c" ()
    (agda/setTexBackend)
    (agda2-compile))
  ;; also enable agda-input in command buffers
  (add-hook 'isearch-mode-hook (lambda () (set-input-method "Agda")))
  ;; fix Evil shifts
  (setq evil-shift-width 2)
  ))

;;;;;;;;;;;
;; LaTeX ;;
;;;;;;;;;;;

(defface my/title '((t (:inherit font-lock-function-name-face :height 2.0)))
  "Face used for \\title command in LaTeX.")
(defface my/chapter '((t (:inherit font-lock-function-name-face :height 2.0)))
  "Face used for \\chapter command in LaTeX.")
(defface my/section '((t (:inherit font-lock-function-name-face :height 1.8)))
  "Face used for \\section command in LaTeX.")
(defface my/subsection '((t (:inherit font-lock-function-name-face :height 1.6)))
  "Face used for \\subsection command in LaTeX.")
(defface my/subsubsection '((t (:inherit font-lock-function-name-face :height 1.4)))
  "Face used for \\subsubsection command in LaTeX.")
(defface my/paragraph '((t (:inherit font-lock-function-name-face :height 1.2)))
  "Face used for \\paragraph command in LaTeX.")
(defface my/site '((t (:inherit font-lock-function-name-face :foreground "DeepSkyBlue1")))
  "Face used for \\site command in LaTeX.")
(defface my/todo '((t (:inherit font-lock-function-name-face :foreground "tomato")))
  "Face used for \\todo command in LaTeX.")
(defface my/alert '((t (:inherit font-lock-function-name-face :foreground "dark orange")))
  "Face used for \\alert command in LaTeX.")

(add-hook 'latex-mode-hook (lambda ()
  ; set sections for folding
  (setq outline-regexp
    (concat (substring outline-regexp 0 4)
            "begin{code}\\|"
            (substring outline-regexp 4)))

  ; remove keywords-3 (_ leading to suscript)
  (setq-local font-lock-defaults
    '((tex-font-lock-keywords tex-font-lock-keywords-1 tex-font-lock-keywords-2)
      nil nil nil nil))
  (setq TeX-parse-self t
        TeX-save-query nil)
  ; keyboard macros
  (setq shell-command-switch "-ic")
  (def-bind insert/textit "C-S-i" ()
    (insert "\\emph{"))
  (def-bind insert/textbf "C-S-b" ()
    (insert "\\textbf{"))
  ; (def-bind searchSection "C-c s" ()
  ;   (evil-search-forward)
  ;   (execute-kbd-macro (read-kbd-macro "/ section{ RET n")))
  ; font size
  ; (set-font 80)
  ; spelling
  (setq ispell-program-name "aspell"
        ispell-dictionary   "british")
  (flyspell-mode)
  (flyspell-buffer)
  ; unicode input
  (require 'agda-input)
  (set-input-method "Agda")
  (set-input-method nil)
  ; prettify symbols
  (setq prettify-symbols-alist '())
  (mapc (lambda (pair) (push pair prettify-symbols-alist))
    '(; TeX commands
      ("\\begin"    . "▽")
      ("\\end"      . "△")
      ("\\item"     . "＊")
      ("\\par"      . "¶")
      ("\\label"    . "☞") ;"🏷")
      ("\\ref"      . "☞")
      ("\\cref"     . "☞")
      ("\\cite"     . "†")
      ("\\footnote" . "‡")
      ("\\newline"  . "⏎")
      ("~"          . "␣")
      ("\\textit"   . "I")
      ("\\emph"     . "I")
      ("\\textbf"   . "B")
      ))
  (font-lock-add-keywords nil
    '(; Basic
      ("\\\\title{\\([^}]*?\\)}"         1 'my/title t)
      ("\\\\chapter{\\([^}]*?\\)}"       1 'my/chapter t)
      ("\\\\subtitle{\\([^}]*?\\)}"      1 'my/section t)
      ("\\\\section{\\([^}]*?\\)}"       1 'my/section t)
      ("\\\\subsection{\\([^}]*?\\)}"    1 'my/subsection t)
      ("\\\\subsubsection{\\([^}]*?\\)}" 1 'my/subsubsection t)
      ("\\\\paragraph{\\([^}]*?\\)}"     1 'my/paragraph t)
      ; Beamer
      ("\\\\begin\[[^}]*?\]{frame}{\\([^}]*?\\)}" 1 'my/section t)
      ("\\\\alert{\\([^}]*?\\)}"                  1 'my/alert t)
      ("\\\\todo{\\([^}]*?\\)}"                   1 'my/alert t)
      ("\\\\alertblock{\\([^}]*?\\)}"             1 'my/alert t)
      ; Custom macros
      ("\\\\site{\\([^}]*?\\)}" 1 'my/site t)
      ("\\\\TODO{\\([^}]*?\\)}" 1 'my/todo t)
      ))
  (prettify-symbols-mode)))

;;;;;;;;;;;;;;
;; Polymode ;;
;;;;;;;;;;;;;;
(define-hostmode poly-latex-hostmode
  :mode 'latex-mode)

(define-innermode poly-agda-innermode
  :mode 'agda2-mode
  :head-matcher "\\\\begin{code}"
  :tail-matcher "\\\\end{code}"
  :head-mode 'host
  :tail-mode 'host)

(define-polymode poly-latex-mode
  :hostmode 'poly-latex-hostmode
  :innermodes '(poly-agda-innermode))

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
    '(("\\.lagda.tex\\'" . poly-latex-mode)
      ("\\.lagda.md\\'"  . agda2-mode)
      ("\\.lagda\\'"     . poly-latex-mode)
      ("\\.agda\\'"      . agda2-mode)
      ("\\.lhs\\'"       . latex-mode)
      ("\\.tex\\'"       . latex-mode)
      )
    auto-mode-alist))

;; openwith
(require 'openwith)
(openwith-mode t)
(setq openwith-associations '(("\\.pdf\\'" "evince --class='Emacs'" (file))))

;; Backup files
(defvar --backup-directory (concat user-emacs-directory "backups"))
(if (not (file-exists-p --backup-directory))
        (make-directory --backup-directory t))
(setq backup-directory-alist `(("." . ,--backup-directory)))
(setq make-backup-files t               ; backup of a file the first time it is saved.
      backup-by-copying t               ; don't clobber symlinks
      version-control t                 ; version numbers for backup files
      delete-old-versions t             ; delete excess backup files silently
      kept-old-versions 6               ; oldest versions to keep when a new numbered backup is made (default: 2)
      kept-new-versions 9               ; newest versions to keep when a new numbered backup is made (default: 2)
      )
;; Autosaves
; (setq auto-save-default t               ; auto-save every buffer that visits a file
;       auto-save-timeout 20              ; number of seconds idle time before auto-save (default: 30)
;       auto-save-interval 200            ; number of keystrokes between auto-saves (default: 300)
;       )

; Raise undo-limit to 100Mb
(setq undo-limit 100000000)

; quickstart project
(defun quickAgda (folder file)
  (execute-kbd-macro (read-kbd-macro
    (concat "C-x C-f ~/git/" folder "/" file ".agda RET")))
  (execute-kbd-macro (read-kbd-macro
    "C-c C-l")))

(defun quickTex (folder file)
  (execute-kbd-macro (read-kbd-macro
    (concat "C-x C-f ~/git/" folder "/" file ".tex RET")))
  (execute-kbd-macro (read-kbd-macro
    "C-c l")))
