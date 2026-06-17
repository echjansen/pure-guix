;; modules/features/desktop.scm

(define-module (features desktop)
  #:use-module (gnu)
  #:use-module (gnu services)
  #:use-module (gnu services desktop)
  #:use-module (gnu packages gnome)
  #:export (desktop-feature))

(define (desktop-feature)
  "Return a feature transformer that adds GNOME to an operating-system.
Assumes the base config starts from %desktop-services, which already
includes gdm-service-type. Adding GDM again would cause a duplicate
service error."
  (lambda (config)
    (operating-system
     (inherit config)
     (services
      ;; Only add gnome-desktop-service-type here.
      ;; %desktop-services (used in systems/t15.scm) already provides GDM.
      (cons (service gnome-desktop-service-type)
            (operating-system-services config)))
     (packages
      ;; gnome-desktop-service-type adds the gnome metapackage automatically.
      ;; Only add packages not covered by the service type.
      (cons gnome-tweaks
            (operating-system-packages config))))))
