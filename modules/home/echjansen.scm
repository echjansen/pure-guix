;; modules/home/echjansen.scm

(define-module (home echjansen)
  #:use-module (guix gexp)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages file)
  #:use-module (home common)
  #:export (echjansen-home))

(define (echjansen-home)
  "Return the home-environment record for echjansen."
  (home-environment
   (packages
    (append
     (list ncurses                      ; clear command
           git
           emacs)
     common-home-packages))

   ;; append allows user-specific services to extend common ones naturally
   (services
    (append
     (common-home-services)
     ;; User-specific home services go here:
     ;; (list (service home-syncthing-service-type) ...)
     (list)))))
