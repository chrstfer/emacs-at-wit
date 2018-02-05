;;; Init.el --- Emacs@WIT init file
;; This file needs to be placed in a folder named .emacs.d inside your home dir
;; --> .emacs.d must contain the folders: elisp and elisp/plugins
;; 
;; Necessary Packages:
;; flycheck helm irony exec-path-from-shell auctex ess 
;; 
;;; Init Code:
(print "hello! I hope you're well.") ;; mad nice lil greetings

;;;; System Specific Configurations
;;   Most of these just need to be here, but tweak around if you will
(set-variable 'package-user-dir "~/.emacs.d/elisp/plugins") ;; define a user package directory for emacs to use
(defconst *is-a-mac* (eq system-type 'darwin)) ;; mac os: gives us the shell's PATH
(if *is-a-mac*
    (add-hook 'after-init-hook 'exec-path-from-shell-initialize))
;;;; End System Specific Config

;;;; Package Initialization Config
(package-initialize) ;; this sets up the packaging system.
(when (>= emacs-major-version 24) ;; if emacs is at version 24 or higher
  (setq package-archives          ;; then set the var package-archives 
	'(("melpa-stable" . "http://stable.melpa.org/packages/") ;; added
	  ("melpa" . "http://melpa.org/packages/")               ;; added
	  ("gnu" . "http://elpa.gnu.org/packages/")
	  ("marmalade" . "http://marmalade-repo.org/packages/"))))

;; ;; fetch the list of packages available 
;; (unless package-archive-contents
;;   (package-refresh-contents))

;; ;; install the missing packages
;; (dolist (package wit-package-list)
;;   (unless (package-installed-p package)
;;     (package-install package)))
(setq wit-packages '(markdown-mode polymode org auctex ess fill-column-indicator exec-path-from-shell use-package))

;; install any packages in jpk-packages, if they are not installed already
(let ((refreshed nil))
  (when (not package-archive-contents)
    (package-refresh-contents)
    (setq refreshed t))
  (dolist (pkg wit-packages)
    (when (and (not (package-installed-p pkg))
             (assoc pkg package-archive-contents))
      (unless refreshed
        (package-refresh-contents)
        (setq refreshed t))
      (package-install pkg))))

;;; require user package
(require 'exec-path-from-shell)
;; ;;; helm
;; (global-set-key (kbd "M-x") 'helm-M-x)
;; ;;; org mode
(add-hook 'org-mode-hook 'visual-line-mode-hook) ;; we generally dont want to truncate in org mode
;;; LaTeX tweaks
(setq TeX-PDF-mode t) ;; default to PDF output for LaTeX

;;; Some interesting packages
;;;     (helm-R company-math hackernews helm-flycheck inline-crypt magit markdown-mode mtg-deck-mode nginx-mode org-journal htmlize muse turing-machine auctex company-shell company-irony-c-headers company-arduino exec-path-from-shell platformio-mode helm flycheck-irony)))

;; ;;; ediff-mode Settings
;; (use-package ediff
;;   :config
;;   (progn
;;     (setq
;;      ;; Always split nicely for wide screens
;;      ediff-split-window-function 'split-window-horizontally)))
;; ;;; End Ediff Mode Settings

;; Emacs for MacOSX -- https://emacsformacosx.com/
   ;;; ESS -- "Emacs Speaks Statistics" with r-markdown integration
;; first do M-x package-install RET polymode
(defun rmd-mode ()
  "ESS Markdown mode for rmd files"
  (interactive)
  ;; (setq load-path 
  ;;   (append (list "path/to/polymode/" "path/to/polymode/modes/")
  ;;       load-path))
  (require 'poly-R)
  (require 'poly-markdown)     
  (poly-markdown+r-mode))

(add-to-list 'auto-mode-alist '("\\.rmd\\'" . rmd-mode))
(add-to-list 'auto-mode-alist '("\\.Rmd\\'" . rmd-mode))
;;; end ESS config


;; ;;; FCI (fill-column-indicator)
;; (use-package fill-column-indicator
;;   :init
;;   (add-hook 'prog-mode-hook  #'fci-mode)
;;   (add-hook 'LaTeX-mode-hook #'fci-mode)
;;   (add-hook 'org-mode-hook   #'fci-mode)

;;   :config
;;   ;; fix for org -> html export
;;   (defun fci-mode-override-advice (&rest args))
;;   (advice-add 'org-html-fontify-code :around
;;               (lambda (fun &rest args)
;;                 (advice-add 'fci-mode :override #'fci-mode-override-advice)
;;                 (let ((result  (apply fun args)))
;;                   (advice-remove 'fci-mode #'fci-mode-override-advice)
;;                   result))))
;; ;;; The fill column is the max length that emacs will allow a line to be when
;;; you type M-q on it. It will intelligently (depending on your mode) split
;;; longer lines without messing up syntax.

;;;;
;;;; Key Bindings
;;;;
;;; these allow one to scroll up and down with meta n/p
;; (global-set-key "\M-n"
;; 		(lambda ()
;; 		  (interactive)
;; 		  (scroll-up 4)))
;; (global-set-key "\M-p"
;; 		(lambda ()
;; 		  (interactive)
;; 		  (scroll-down 4)))
;;; Default org-mode keybindings
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)

;;; MacOSX Customized Themes
(defun my/setup-osx-fonts ()
  (interactive)
  (when (eq system-type 'darwin)
    ;;(set-fontset-font "fontset-default" 'symbol "Monaco")
    ;;(set-default-font "Fantasque Sans Mono")
    ;;(set-default-font "Monaco")
    ;;(set-default-font "Anonymous Pro")
    ;;(set-default-font "inconsolata")
    ;;(set-default-font "Bitstream Vera Sans Mono")
    ;;(set-default-font "Menlo")
    ;;(set-default-font "Source Code Pro")
    ;;(set-default-font "Mensch")
    (set-face-attribute 'default nil :height 120)
    (set-face-attribute 'fixed-pitch nil :height 120)

    ;; Anti-aliasing
    (setq mac-allow-anti-aliasing t)))

(when (eq system-type 'darwin)
  (add-hook 'after-init-hook #'my/setup-osx-fonts))
;;; End Custom Theme


;; The (server-start...) command lets you can open other emacs windows
(server-start) ;; while sharing the same set of buffers between them. 
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (ess use-package polymode markdown-mode fill-column-indicator exec-path-from-shell auctex))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(print "Done with initialization.")
(provide 'init) ;; This lets emacs know that is is our initialization file.
