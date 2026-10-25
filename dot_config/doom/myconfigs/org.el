;;; myconfigs/org.el -*- lexical-binding: t; -*-

(setq org-directory "~/mi-gemelo-digital/")
(setq org-agenda-start-on-weekday 1)
(setq calendar-week-start-day 1)
(setq org-agenda-files
      (directory-files-recursively "~/mi-gemelo-digital/" "\\.org$"))

(defun my/org-skip-subtree-if-priority (priority)
  "Skip an agenda subtree if it has a priority of PRIORITY.

PRIORITY may be one of the characters ?A, ?B, or ?C."
  (let ((subtree-end (save-excursion (org-end-of-subtree t)))
        (pri-value (* 1000 (- org-lowest-priority priority)))
        (pri-current (org-get-priority (thing-at-point 'line t))))
    (if (= pri-value pri-current)
        subtree-end
      nil)))

(defun my/org-skip-subtree-if-habit ()
  "Skip an agenda entry if it has a STYLE property equal to \"habit\"."
  (let ((subtree-end (save-excursion (org-end-of-subtree t))))
    (if (string= (org-entry-get nil "STYLE") "habit")
        subtree-end
      nil)))

(defun my/org-agenda-skip-if-no-agenda ()
  "Devuelve el fin del subárbol si tiene la propiedad :NO_AGENDA: t."
  (let ((subtree-end (save-excursion (org-end-of-subtree t))))
    (when (string= "t" (org-entry-get nil "NO_AGENDA"))
      subtree-end)))

(setq org-agenda-custom-commands
      '(;; ---------------------------------------------------------
        ;; JOB "J"
        ;; ---------------------------------------------------------

        ("j" . "job")

        ("jd" "daily view"
         ((agenda ""
                  ((org-agenda-span 3)
                   (org-deadline-warning-days 0)
                   (org-agenda-skip-deadline-prewarning-if-scheduled t)
                   (org-agenda-start-day "0d")
                   (org-agenda-prefix-format " %i %-25:c%?-12t% s")
                   ;; Añadido para filtrar la vista de agenda diaria:
                   (org-agenda-skip-function 'my/org-agenda-skip-if-no-agenda)))
          (alltodo ""
                   ((org-agenda-skip-function
                     (lambda ()
                       ;; Evaluamos primero si tiene :NO_AGENDA:, si no, evaluamos el resto
                       (or (my/org-agenda-skip-if-no-agenda)
                           (org-agenda-skip-if nil '(scheduled deadline)))))
                    (org-agenda-overriding-header "TODO-LIST:")
                    (org-agenda-prefix-format " %i %-25:c"))))
         ((org-agenda-files (append
                             (directory-files-recursively "~/mi-gemelo-digital/job/" "\\.org$")
                             (list "~/mi-gemelo-digital/birthdays.org"
                                   "~/mi-gemelo-digital/calendario-eventos.org")))
          (org-agenda-compact-blocks nil)
          (org-agenda-block-separator #x2500)
          (org-agenda-start-with-log-mode t)))

        ;; ---------------------------------------------------------
        ;; PERSONAL "P"
        ;; ---------------------------------------------------------

        ("p" . "personal")

        ("pd" "daily view"
         ((agenda ""
                  ((org-agenda-span 3)
                   (org-agenda-start-day "0d")
                   (org-deadline-warning-days 0)
                   (org-agenda-skip-deadline-prewarning-if-scheduled t)
                   (org-habit-show-habits nil)
                   (org-agenda-prefix-format " %i %-25:c%?-12t% s")
                   ;; Añadido para filtrar la vista de agenda diaria:
                   (org-agenda-skip-function 'my/org-agenda-skip-if-no-agenda)))
          (alltodo ""
                   ((org-agenda-skip-function
                     (lambda ()
                       ;; Encadenamos en el 'or' para que salte si se cumple cualquiera
                       (or (my/org-agenda-skip-if-no-agenda)
                           (my/org-skip-subtree-if-habit)
                           (my/org-skip-subtree-if-priority ?A)
                           (org-agenda-skip-if nil '(scheduled deadline)))))
                    (org-agenda-overriding-header "TODO-LIST:")
                    (org-agenda-prefix-format " %i %-25:c"))))
         ((org-agenda-files (append
                             (directory-files-recursively "~/mi-gemelo-digital/personal/" "\\.org$")
                             (list "~/mi-gemelo-digital/birthdays.org"
                                   "~/mi-gemelo-digital/calendario-eventos.org")))
          (org-agenda-compact-blocks nil)
          (org-agenda-block-separator #x2500)
          (org-agenda-start-with-log-mode t)))))

(setq org-agenda-sort-notime-is-late nil)

(defun my/pop-to-org-agenda (&optional split)
  "Visit the org agenda, in the current window or a SPLIT."
  (interactive "P")
  (if (string-prefix-p "ES99P4brP0pSx2I" (system-name))
      (org-agenda nil "jd")
    (org-agenda nil "pd"))
  (when (not split)
    (delete-other-windows)))

(define-key evil-normal-state-map (kbd "S-SPC") 'my/pop-to-org-agenda)

(after! calendar
  (setq calendar-week-start-day 1))

;; log into LOGBOOK drawer
(setq org-log-into-drawer t)

(after! org
  (after! org
    (setq org-clock-clocktable-default-properties
          '(:scope file
            :maxlevel 3
            :block thisweek
            :step day
            :compact t)))
  (setq org-start-on-weekday 1)
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
  :config
  (setq org-timeblock-span 3)
  (setq org-timeblock-scale-options '(6 . 24)))

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

  ;; El ACK de TMR debe ejecutarse antes que nuestro clock-out.
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
