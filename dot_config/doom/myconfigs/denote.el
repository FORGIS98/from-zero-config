;;; myconfigs/denote.el -*- lexical-binding: t; -*-

(use-package! denote
  :defer nil
  :ensure t
  :hook (dired-mode . denote-dired-mode)
  :config

  (setq denote-directory
        (if (string-prefix-p "ES99P4brP0pSx2I" (system-name))
            (expand-file-name "~/mi-gemelo-digital/job/denote")
          (expand-file-name "~/mi-gemelo-digital/personal/denote")))

  (denote-rename-buffer-mode 1)

  (map! :leader
        :prefix ("d" . "denote")
        :desc "search or create file"        "n" #'denote-open-or-create
        :desc "rename file"                  "r" #'denote-rename-file
        :desc "link note"                    "l" #'denote-link
        :desc "backlinks"                    "b" #'denote-backlinks
        :desc "dired notes"                  "d" #'denote-dired
        :desc "grep notes"                   "g" #'denote-grep
        :desc "template"                     "t" #'denote-template)
  (setq denote-known-keywords '()))

(use-package! denote-silo
  :defer nil
  :ensure t
  :config
    (setq denote-silo-directories
          (list denote-directory
                "~/mi-gemelo-digital/personal/denote"
                "~/mi-gemelo-digital/job/denote"))
  (map! :leader
        :prefix ("d" . "denote")
        (:prefix ("s" . "silo")
        :desc "open or create note in silo"        "n" #'denote-silo-open-or-create
        :desc "select silo and run a command"      "s" #'denote-silo-select-silo-then-command
        :desc "silo dired"                         "d" #'denote-silo-dired)))

;; denote templates
(setq denote-templates
      `((drs . ,(concat "#+startup: overview\n\n"
                        "DRS:\nVC:\nInicio INTE:\nInicio CERT:\nPROD:\n\n"
                        "* SHAREPOINT:\n"
                        "* CONTEXTO - QUE SE QUIERE?\n"
                        "* SOFTWARE AFECTADO\n"
                        "* FLUJOS DE EJECUCION\n"
                        "* DUDAS\n"
                        "* TAREAS\n:properties:\n:visibility: all\n:end:\n"
                        ))
        (redmine . ,(concat "#+startup: overview\n\n"
                            "Redmine:\nPROD:\n\n"
                            "* QUE SE ARREGLA?\n"
                            "* SOFTWARE AFECTADO\n"
                            "* FLUJOS DE EJECUCION\n"
                            "* TAREAS\n:properties:\n:visibility: all\n:end:\n"
                            ))
        (prueba . ,(concat "* H1\n"
                           "* H2\n"
                           ))))
