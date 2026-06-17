;; modules/home/common.scm

(define-module (home common)
  #:use-module (guix gexp)
  #:use-module (gnu home)
  #:use-module (gnu home services shells)
  #:export (common-home-packages
            common-home-services))

(define common-home-packages
  ;; nss-certs is in %base-packages since Guix 1.5.0 on Guix System.
  ;; On foreign distros, validate per deployment before removing it.
  (list))

(define (common-home-services)
  "Return home services common to all users."
  (list
   (service home-bash-service-type
            (home-bash-configuration
             (guix-defaults? #t)
             (aliases '(("ll" . "ls -lh --color=auto")
                        ("la" . "ls -lAh --color=auto")
                        ("g"  . "git")))
             (bashrc
              (list (plain-file "common-bashrc" "\
export EDITOR=emacs
export PAGER=less
export HISTFILE=$XDG_CACHE_HOME/.bash_history
")))))))
