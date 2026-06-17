;; modules/services/backup.scm

(define-module (services backup)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (gnu packages backup)
  #:export (backup-service-type
            backup-configuration
            make-backup-configuration
            backup-configuration?))

(define-record-type* <backup-configuration>
  backup-configuration make-backup-configuration
  backup-configuration?
  (repository  backup-configuration-repository)
  (paths       backup-configuration-paths
               (default '("/home" "/etc")))
  (schedule    backup-configuration-schedule
               (default "0 3 * * *")))

(define (backup-shepherd-service config)
  (list
   (shepherd-service
    (provision '(backup))
    (documentation "Periodic backup service via restic.")
    ;; NOTE: Shepherd 1.0 timer support. Validate make-timer against your
    ;; installed Shepherd version before deploying. If unavailable, use mcron.
    (start #~(make-timer
              #$(backup-configuration-schedule config)
              (lambda ()
                (system* #$(file-append restic "/bin/restic")
                         "backup"
                         "--repo" #$(backup-configuration-repository config)
                         #$@(backup-configuration-paths config)))))
    (stop #~(make-kill-destructor)))))

(define backup-service-type
  (service-type
   (name 'backup)
   (extensions
    (list (service-extension shepherd-root-service-type
                             backup-shepherd-service)))
   (description "Periodic backup using restic.")))
