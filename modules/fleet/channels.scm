;; modules/fleet/channels.scm
;; Single source of truth for fleet channel pins.
;; Imported by system configs (guix-service-type) and re-exported
;; by the root channels.scm for use with guix time-machine.

(define-module (fleet channels)
  #:use-module (guix channels)
  #:export (%fleet-channels))

(define %fleet-channels
  (list
   (channel
    (name 'guix)
    (url "https://git.guix.gnu.org/guix.git")
    (branch "master")
    (commit "d213f3e0765e810bc0c040e8d416ca2954287926")
    (introduction
     (make-channel-introduction
      "9edb3f66fd807b096b48283debdcddccfea34bad"
      (openpgp-fingerprint
       "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA"))))))
