;; modules/profiles/server.scm
;; Archetype: hardened SSH + containers

(define-module (profiles server)
  #:use-module (profiles base)
  #:use-module (features server)
  #:use-module (features containers)
  #:export (server-profile))

(define (server-profile base-config)
  "Apply the server archetype to BASE-CONFIG."
  (apply-features base-config
                  (list (server-feature)
                        (containers-feature))))
