;;; myconfigs/general.el -*- lexical-binding: t; -*-

(setq org-directory "~/mi-gemelo-digital/")

;; log into LOGBOOK drawer
(setq org-log-into-drawer t)

(after! org
  (setq org-log-done 'time
        org-clock-clocktable-default-properties
        '(:scope file
          :maxlevel 3
          :block thisweek
          :step day
          :compact t))
  (setq org-capture-templates
        '(;; --- Grupo de TRABAJO (tecla "w") ---
          ("j" "job")
          ("jt" "tasks" entry
           (file "job/todo.org")
           "* TODO %?\n"
           :prepend t)
          ("jm" "meeting" entry
           (file "job/meetings.org")
           "* REU %?")
          ("jj" "journal" entry
           (file+datetree "job/journal.org")
           "* %?"
           :unnarrowed t)

          ;; --- Grupo PERSONAL (tecla "p") ---
          ("p" "personal")
          ("pt" "tasks" entry
           (file "personal/todo.org")
           "* TODO %?\n"
           :prepend t)
          ("pd" "distracciones" item
           (file "personal/cosas-que-me-distraen.org")
           "- [ ] %?\n"
           :prepend t)
          ("pj" "journal" entry
           (file+datetree "personal/journal.org")
           "* ¿En que he fallado?\n* ¿Que he hecho bien?\n* ¿Que podría haber hecho de forma diferente?%?"
           :unnarrowed t))))

(map! :leader
      :desc "capture something"           "x" #'org-capture
      :desc "pop up a persistent scratch buffer" "X" #'doom/open-scratch-buffer)

(map! :leader
      (:prefix-map ("o" . "open")
                   (:prefix-map ("c" . "calendar")
                    :desc "timeblock"                      "t" #'org-timeblock)))

(after! org-timeblock
  (setq org-timeblock-span 3
        org-timeblock-scale-options '(6 . 24)))

(map! :leader
      (:prefix "t"
       :desc "start tmr"                "t" #'tmr-with-details
       :desc "list"                     "l" #'tmr-tabulated-view
       :desc "pomodoro with clock-in"   "s" #'my/org-clock-in-with-tmr
       :desc "remove"                   "c" #'tmr-remove))

(setq org-enforce-todo-dependencies t)

(after! tmr
  (setq tmr-dateline-file (concat doom-cache-dir "tmr-dateline"))

  (defun my/org-clock-out-on-tmr-ack (&rest _)
    "Clock out de Org despues de reconocer un TMR."
    (when (org-clock-is-active)
      (org-clock-out nil t)
      (message "TMR ACK: clock-out realizado.")))

  (add-hook 'tmr-timer-finished-functions
            #'my/org-clock-out-on-tmr-ack
            t))

(defun my/org-clock-in-with-tmr (duration description)
  "Inicia Org clock y un TMR con ACK. Utiliza 25m por defecto."
  (interactive
   (let ((default-heading (org-get-heading t t t t)))
     (list (read-string "Duración TMR (ej. 25m) [defecto: 25]: " nil nil "25")
           (read-string (format "Descripción [defecto: %s]: " default-heading) nil nil default-heading))))
  (org-clock-in)
  (tmr duration description t))
