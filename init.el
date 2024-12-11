;;; This fixed garbage collection, makes emacs start up faster ;;;;;;;
(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6)

(defvar startup/file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(defun startup/revert-file-name-handler-alist ()
  (setq file-name-handler-alist startup/file-name-handler-alist))

(defun startup/reset-gc ()
  (setq gc-cons-threshold 16777216
        gc-cons-percentage 0.1))

(add-hook 'emacs-startup-hook 'startup/revert-file-name-handler-alist)
(add-hook 'emacs-startup-hook 'startup/reset-gc)

;;; Package management
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("ELPA"  . "https://tromey.com/elpa/")
                         ("gnu"   . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("org"   . "https://orgmode.org/elpa/")))
(package-initialize)

;;; Bootstrapping use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;;; Jedi configuration for Python
(use-package jedi
  :ensure t
  :config
  (setq jedi:complete-on-dot t) ;; Enable autocompletion after "."
  (setq jedi:environment-root "default") ;; Name of the virtual environment
  (setq jedi:environment-virtualenv
        '("python3" "-m" "venv")) ;; Command to create the virtual environment
  (add-hook 'python-mode-hook 'jedi:setup)) ;; Add Jedi to Python mode

;;; Optional: Automatically install Jedi server if not present
(defun ensure-jedi-server ()
  "Ensure the Jedi server is installed and configured."
  (interactive)
  (unless (file-exists-p "~/.emacs.d/.python-environments/default")
    (jedi:install-server)))

(add-hook 'python-mode-hook 'ensure-jedi-server)

;;; Load config.org if it exists
(when (file-readable-p "~/.emacs.d/config.org")
  (org-babel-load-file (expand-file-name "~/.emacs.d/config.org")))

;;; Email configuration if exists
(when (file-readable-p "~/.email/email.org")
  (org-babel-load-file (expand-file-name "~/.email/email.org")))

;;; Customization
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#0a0814" "#f2241f" "#67b11d" "#b1951d" "#4f97d7" "#a31db1" "#28def0" "#b2b2b2"])
 '(package-selected-packages
   '(jedi maxiuma f auctex telephone-line auto-complete rainbow-delimiters ivy projectile 
          magit org-bullets use-package))
 '(pos-tip-background-color "#36473A")
 '(pos-tip-foreground-color "#FFFFC8"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "#282c34" 
               :foreground "#abb2bf" :inverse-video nil :box nil 
               :strike-through nil :overline nil :underline nil 
               :slant normal :weight regular :height 138 :width normal 
               :foundry "UKWN" :family "Nimbus Mono PS")))))

