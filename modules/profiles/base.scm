;; modules/profiles/base.scm
;; Shared feature composition helper.

(define-module (profiles base)
  #:use-module (srfi srfi-1)
  #:export (apply-features))

(define (apply-features base-config features)
  "Apply a list of feature transformer functions to BASE-CONFIG using left fold.
Each feature is a procedure: operating-system -> operating-system."
  (fold (lambda (feature config) (feature config))
        base-config
        features))
