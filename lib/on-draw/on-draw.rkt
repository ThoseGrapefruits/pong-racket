#lang typed/racket/base

(require
  pict3d
  "./on-draw-game-over.rkt"
  "./on-draw-main-menu.rkt"
  "./on-draw-pause-menu.rkt"
  "./on-draw-play.rkt"
  "../config.rkt"
  "../state/state.rkt")

(provide on-draw)

; GLOBAL SETTINGS

(current-pict3d-fov FOV)
(current-material (material #:ambient 0
                            #:diffuse 0
                            #:specular 0
                            #:roughness 0.3))

; RENDER — ON-DRAW

(: on-draw : State Natural Flonum -> Pict3D)
(define (on-draw s n t)
  (define drawn (combine
                 (on-draw-play       s)
                 (on-draw-game-over  s)
                 (on-draw-main-menu  s)
                 (on-draw-pause-menu s)))
  (set-box! (State-pict-last s) drawn)
  drawn)

; RENDER — CONSTANTS

(: axes Pict3D)
(define axes
  (combine (with-emitted (emitted "cyan" 2)
             (arrow origin -x))
           (with-emitted (emitted "magenta" 2)
             (arrow origin -y))
           (with-emitted (emitted "yellow" 2)
             (arrow origin -z))))
