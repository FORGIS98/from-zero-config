;;; myconfigs/org-agenda.el -*- lexical-binding: t; -*-

(setq org-agenda-start-on-weekday 1
      calendar-week-start-day 1
      org-agenda-files
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
                   (org-agenda-skip-function 'my/org-agenda-skip-if-no-agenda)))
          (alltodo ""
                   ((org-agenda-skip-function
                     (lambda ()
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
                   (org-agenda-prefix-format " %i %-25:c%?-12t% s")
                   (org-agenda-skip-function 'my/org-agenda-skip-if-no-agenda)))
          (alltodo ""
                   ((org-agenda-skip-function
                     (lambda ()
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

(after! org
  (setq org-start-on-weekday 1))
