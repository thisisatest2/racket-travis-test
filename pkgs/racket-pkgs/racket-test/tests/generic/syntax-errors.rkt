#lang racket

(require racket/generic rackunit)

(define-namespace-anchor generic-env)

(define-syntax-rule (check-good-syntax exp ...)
  (begin
    (check-not-exn
     (lambda () (eval '(module foo racket/base
                         (require racket/generic)
                         exp)
                      (namespace-anchor->namespace generic-env))))
    ...))

(define-syntax-rule (check-bad-syntax exp ...)
  (begin
    (check-exn
     exn:fail:syntax?
     (lambda () (eval '(module foo racket/base
                         (require racket/generic)
                         exp)
                      (namespace-anchor->namespace generic-env))))
    ...))

(check-good-syntax

 (define-generics stream
   (stream-first stream)
   (stream-rest stream)
   (stream-empty? stream))

 (define-generics stream
   #:defined-table stream-table
   (stream-first stream)
   (stream-rest stream)
   (stream-empty? stream)
   #:defaults
   ([list?
     (define stream-first car)
     (define stream-rest cdr)
     (define stream-empty? null?)]))

 (define-generics stream
   #:defined-table stream-table
   #:defaults
   ([list?
     (define stream-first car)
     (define stream-rest cdr)
     (define stream-empty? null?)])
   (stream-first stream)
   (stream-rest stream)
   (stream-empty? stream))

 (define-generics stream
   (stream-first stream)
   (stream-rest stream)
   (stream-empty? stream)
   #:defined-table stream-table
   #:defaults
   ([list?
     (define stream-first car)
     (define stream-rest cdr)
     (define stream-empty? null?)]))

 (define-generics stream
   (stream-first stream)
   (stream-rest stream)
   (stream-empty? stream)
   #:defaults
   ([list?
     (define stream-first car)
     (define stream-rest cdr)
     (define stream-empty? null?)])
   #:defined-table stream-table))

(check-bad-syntax

 (define-generics stream
   (stream-first stream)
   (stream-rest stream)
   #:defaults
   ([list?
     (define stream-first car)
     (define stream-rest cdr)
     (define stream-empty? null?)])
   (stream-empty? stream))

 (define-generics stream
   (stream-first stream)
   (stream-rest stream)
   #:defined-table stream-table
   (stream-empty? stream))

 (define-generics stream
   (stream-first stream)
   (stream-rest stream)
   (stream-empty? stream)
   #:defaults
   foo)

 (define-generics stream
   (stream-first stream)
   (stream-rest stream)
   (stream-empty? stream)
   #:defaults
   ([list?
     (define stream-first car)
     (define stream-rest cdr)
     (define stream-rest 5)
     (define stream-empty? null?)]))

 (define-generics stream
   (stream-first stream)
   (stream-rest stream)
   (stream-empty? stream)
   #:defaults
   ([])))