#lang typed/racket/base

(require racket/set
         "../state/state.rkt")

(provide just-pressed?)

(: just-pressed? : State String String * -> Boolean)
(define (just-pressed? s k-pressed . k-targets)
  (ormap (λ ([k-target : String])
           (and (string=? k-pressed k-target)
                (not (set-member? (State-pressed s) k-pressed))))
         k-targets))