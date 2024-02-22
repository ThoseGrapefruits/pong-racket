#lang typed/racket

(require
  pict3d
  "./camera.rkt"
  "./util.rkt"
  "../config.rkt"
  "../state/state.rkt")

(provide position-screen-space-pixels
position-screen-space-relative)

; Get a transformation that moves an object from the origin to the given (x,y,z)
; coordinate in screen-space, where (0,0,1) is the top-left of the camera
; viewport and (SCREEN-WIDTH,SCREEN-HEIGHT,1) is the bottom-right, placed in a
; z-plane 1 unit away from the camera.
(: position-screen-space-pixels : (->* (State Flonum Flonum) (Flonum) Affine))
(define (position-screen-space-pixels s x y [z 1.0])
  (define cam-t (camera-transform-pong s))
  (define z-near (* z CAMERA-SPACE-DISTANCE))
  (define dir ((camera-ray-dir cam-t
                               #:width SCREEN-WIDTH
                               #:height SCREEN-HEIGHT
                               #:z-near z-near)
               (wrap-within x SCREEN-WIDTH-INEXACT)
               (wrap-within y SCREEN-HEIGHT-INEXACT)))
  (affine-compose (move dir)
                  cam-t
                  (scale z-near)))

; Get a transformation that moves an object from the origin to the given (x,y,z)
; coordinate in screen-space, where (-1,-1,1) is the top-left of the camera
; viewport, and (1,1,1) is the bottom-right, placed in a z-plane 1 unit away
; from the camera.
(: position-screen-space-relative : (->* (State Flonum Flonum) (Flonum) Affine))
(define (position-screen-space-relative s x y [z 1.0])
  (position-screen-space-pixels
   s
   (scale--1-1 x SCREEN-WIDTH)
   (scale--1-1 y SCREEN-HEIGHT)
   z))