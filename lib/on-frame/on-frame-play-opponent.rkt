#lang typed/racket/base

(require
  (only-in pict3d
           Pos
           pos-x
           pos-y)
  "../config.rkt"
  "../state/state.rkt"
  "../util/player.rkt"
  "../util/pid.rkt")

(provide on-frame-play-opponent)

(: on-frame-play-opponent : State-Play -> State-Play)
(define (on-frame-play-opponent s)
  (define ball (State-Play-ball s))
  (define ball-y (pos-y (Ball-pos ball)))
  (define opponent (State-Play-opponent s))
  (define pid-position (Opponent-pid-position opponent))
  (define opponent-y (Opponent-y opponent))
  (define pos-predicted-maybe
    (findf (λ ([p : Pos]) (negative? (pos-x p)))
           (State-Play-ball-predicted-pos-ends s)))
  (define pos-predicted (or pos-predicted-maybe null))
  (define pos-y-desired
    (cond [(null? pos-predicted) ball-y]
          [(> (pos-x pos-predicted) OPPONENT-X-COLLISION) ball-y]
          [else (pos-y pos-predicted)]))
  (define dt (unbox (State-dt s)))
  (define max-err (* dt OPPONENT-SPEED))
  ; clamping here helps the pid controller's integral not get mad when it can't
  ; reach the edge of the stage
  (define pos-diff (- (clamp-bumper-y pos-y-desired) opponent-y))
  (define pos-diff-clamped (max (- max-err) (min max-err pos-diff)))
  (define pos-y-next (+ (pid-step! pid-position pos-diff-clamped dt)
                        opponent-y))
  (struct-copy
   State-Play s
   [opponent
    (struct-copy
     Opponent opponent
     [y (clamp-bumper-y pos-y-next)])]))
