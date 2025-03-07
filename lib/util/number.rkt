#lang typed/racket/base

(require racket/math)

(provide (all-defined-out))

(: get-number-place : Integer Integer Integer -> Integer)
(define (get-number-place n over under)
  (exact-floor (/ (exact->inexact (- (modulo n over) (modulo n under)))
                  (exact->inexact under))))

(: clamp : Flonum Flonum Flonum -> Flonum)
(define (clamp x low high)
  (cond
    [(< high low) (error "low must be less than high")]
    [else (max low (min high x))]))

(: digits : (->* (Nonnegative-Integer) (Nonnegative-Integer) (Listof Nonnegative-Integer)))
(define (digits n [radix 10])
  (define-values (q r) (quotient/remainder n radix))
  (cons r (if (= 0 q)
              null
              (digits q radix))))

(: lerp : Flonum Flonum Flonum -> Flonum)
(define (lerp start end ratio)
  (+ start (* ratio (- end start))))

(: random/0-1 : -> Flonum)
(define (random/0-1)
  (/ (exact->inexact (random 4294967087))
     4294967086.0))

(: within? : Flonum Flonum Flonum -> Boolean)
(define (within? x low high)
  (cond
    [(< high low)
     (and (>= x high)
          (<= x low))]
    [else
     (and (<= x high)
          (>= x low))]))
