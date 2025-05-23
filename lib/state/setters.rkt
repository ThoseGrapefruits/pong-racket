#lang typed/racket/base

(require
  (only-in racket/set set-add set-remove)
  (only-in racket/string string-prefix?)
  "../util/player.rkt"
  "./state.rkt"
  "./syntax.rkt")

(provide (all-defined-out))

(: State-set-key-pressed : State-Any String Boolean -> State-Any)
(define (State-set-key-pressed s key pressed?)
  (cond
    ; ignore mouse wheel events (optimization)
    [(string-prefix? key "wheel-") s]
    [else
     (State-update-parent
      s
      [pressed #:parent State
               (cond
                 [pressed? (set-add (State-pressed s) key)]
                 [else (set-remove (State-pressed s) key)])])]))

(: State-Play-set-player-position (->* (State-Play Flonum) (Flonum) State-Play))
(define (State-Play-set-player-position s y [y-desired #f])
  (struct-copy
   State-Play s
   [player (struct-copy
            Player (State-Play-player s)
            [y         (clamp-bumper-y y)]
            [y-desired (and y-desired (clamp-bumper-y y-desired))])]))
