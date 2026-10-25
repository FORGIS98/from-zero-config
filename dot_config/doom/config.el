;;; new-config.el -*- lexical-binding: t; -*-

;; Datos personales
(setq user-full-name "Jorge Sol"
      user-mail-address "jorgesolgonzalez1998@gmail.com")

;; Config global
(setq doom-theme 'doom-monokai-pro)
(setq display-line-numbers-type 'relative)
(setq frame-title-format "Emacs")
(setq calendar-holidays nil)
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 16))

;; Backups
(setq create-lockfiles nil)
(setq backup-directory-alist `(("." . ,(concat user-emacs-directory "backups"))))
(setq auto-save-file-name-transforms `((".*" ,(concat user-emacs-directory "autosave/") t)))

;; Para usar vterm como uso kitty
(add-hook 'vterm-mode-hook
          (lambda ()
            (define-key vterm-mode-map (kbd "C-j") #'vterm-send-down)))

(load! "myconfigs/denote")
(load! "myconfigs/org")
