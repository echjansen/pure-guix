;; modules/features/containers.scm

(define-module (features containers)
  #:use-module (gnu)
  #:use-module (gnu services containers)
  #:use-module (gnu packages containers)
  #:export (containers-feature))

(define (containers-feature)
  "Return a feature transformer adding Podman and OCI container support."
  (lambda (config)
    (operating-system
     (inherit config)
     (services
      ;; containerd-service-type must be listed separately in Guix 1.5.0
      (cons* (service containerd-service-type)
             (operating-system-services config)))
     (packages
      (cons podman
            (operating-system-packages config))))))
