;; modules/profiles/laptop.scm
;; Archetype: desktop + development

(define-module (profiles laptop)
  #:use-module (profiles base)
  #:use-module (features desktop)
  #:use-module (features development)
  #:export (laptop-profile))

(define (laptop-profile base-config)
  "Apply the laptop archetype (desktop + development) to BASE-CONFIG."
  (apply-features base-config
                  (list (desktop-feature)
                        (development-feature))))
