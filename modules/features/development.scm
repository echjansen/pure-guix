;; modules/features/development.scm

(define-module (features development)
  #:use-module (gnu)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages build-tools)
  #:export (development-feature))

(define (development-feature)
  "Return a feature transformer that adds development tools to an operating-system."
  (lambda (config)
    (operating-system
     (inherit config)
     (packages
      (cons* git
             gnu-make
             (operating-system-packages config))))))
