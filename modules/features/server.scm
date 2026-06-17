;; modules/features/server.scm

(define-module (features server)
  #:use-module (gnu)
  #:use-module (gnu services ssh)
  #:export (server-feature))

(define (server-feature)
  "Return a feature transformer adding a hardened SSH daemon.
Authorized keys are NOT set here — they are user-specific and belong
in the machine definition via simple-service + openssh-service-type."
  (lambda (config)
    (operating-system
     (inherit config)
     (services
      (cons (service openssh-service-type
                     (openssh-configuration
                      (permit-root-login #f)
                      (password-authentication? #f)))
            (operating-system-services config))))))
