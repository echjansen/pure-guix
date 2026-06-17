;; modules/profiles/workstation.scm
;; Archetype: desktop + development + multimedia

(define-module (profiles workstation)
  #:use-module (profiles base)
  #:use-module (features desktop)
  #:use-module (features development)
  #:use-module (features multimedia)
  #:export (workstation-profile))

(define (workstation-profile base-config)
  "Apply the workstation archetype to BASE-CONFIG."
  (apply-features base-config
                  (list (desktop-feature)
                        (development-feature)
                        (multimedia-feature))))
