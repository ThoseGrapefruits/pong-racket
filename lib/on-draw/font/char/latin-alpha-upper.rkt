#lang typed/racket/base

(require
  (only-in pict3d
           arc
           combine
           dir
           move-x
           pos+
           rectangle
           +x
           +y
           -x
           -y)
  (only-in racket/math degrees->radians)
  "../statics/guides.rkt"
  "../statics/measurements.rkt"
  "../statics/memoize.rkt"
  "../util/cirque.rkt"
  "../util/quad-thicc.rkt")

(provide (all-defined-out))

(: UPPER-ARC-OFFSET : Flonum)
(define UPPER-ARC-OFFSET 15.0)

(define char:A
  (make-Char-3D-memoized
   #\A
   WIDTH-EM-3/4
   (λ ()
     (define half-width (- WIDTH-EM-5/8 WIDTH-STROKE-1/2))
     (define cross-bottom-height (- HEIGHT-X WIDTH-STROKE))
     (define cross-inset (* cross-bottom-height (/ half-width HEIGHT-CAP)))
     (define cross-radius (- WIDTH-EM-5/16 cross-inset))
     (combine
      ; left ascender
      (quad-thicc (pos+ LINE/CAP/CENTER-5/8 +x WIDTH-STROKE-1/2)
                  (pos+ LINE/CAP/CENTER-5/8 -x WIDTH-STROKE-1/2)
                  (pos+ LINE/BASE/START     +x 0.0)
                  (pos+ LINE/BASE/START     +x WIDTH-STROKE))
      ; right ascender
      (quad-thicc (pos+ LINE/CAP/CENTER-5/8 +x WIDTH-STROKE-1/2)
                  (pos+ LINE/CAP/CENTER-5/8 -x WIDTH-STROKE-1/2)
                  (pos+ LINE/BASE/END-5/8   -x WIDTH-STROKE)
                  (pos+ LINE/BASE/END-5/8   +x 0.0))
      ; cross
      (rectangle (pos+ LINE/MEAN/CENTER-5/8 +y WIDTH-STROKE-1/2)
                 (dir cross-radius WIDTH-STROKE-1/2 DEPTH-Z-1/2))))))

(define char:B
  (make-Char-3D-memoized
   #\B
   WIDTH-EM-5/8
   (λ ()
     (define overangle 15.0)
     (combine
      ; ascender
      (rectangle (pos+ LINE/MID/START +x WIDTH-STROKE-1/2)
                 (dir WIDTH-STROKE-1/2 HEIGHT-CAP-1/2 DEPTH-Z-1/2))
      ; loops
      (move-x (combine (cirque-y-3/4 #:arc (arc (- -90.0 overangle) (+ 90.0 overangle))
                                     #:basis 'y)
                       (cirque-x-link-3/4 #:arc (arc -90.0 (+ 90.0 overangle))
                                          #:basis 'y))
              (- WIDTH-STROKE WIDTH-EM-3/8))))))

(define char:C
  (make-Char-3D-memoized
   #\C
   WIDTH-EM-5/8
   (λ ()
     (combine
      ; top arc
      (cirque-y-1/2 #:arc (arc -180.0 (- UPPER-ARC-OFFSET)) #:basis 'x)
      ; connector y
      (rectangle (pos+ LINE/MEAN/START
                       (dir WIDTH-STROKE-1/2 (- HEIGHT-Y-1/4) 0.0))
                 (dir WIDTH-STROKE-1/2 HEIGHT-Y-1/4 DEPTH-Z-1/2))
      ; connector x
      (rectangle (pos+ LINE/MEAN/START
                       (dir WIDTH-STROKE-1/2 HEIGHT-X-1/4 0.0))
                 (dir WIDTH-STROKE-1/2 HEIGHT-X-1/4 DEPTH-Z-1/2))
      ; bottom arc
      (cirque-x-1/2 #:arc (arc 15.0 180.0) #:basis 'x)))))

(define char:D
  (make-Char-3D-memoized
   #\D
   WIDTH-EM-5/8
   (λ ()
     (combine
      ; left ascender
      (rectangle (pos+ LINE/MID/START +x WIDTH-STROKE-1/2)
                 (dir WIDTH-STROKE-1/2 HEIGHT-CAP-1/2 DEPTH-Z-1/2))
      (move-x (combine
               ; top arc
               (cirque-y-3/4 #:arc (arc (- -90.0 UPPER-ARC-OFFSET) 0.0)
                             #:basis 'x)
               ; right connector y
               (rectangle (pos+ LINE/MEAN/END-3/4
                                (dir (- WIDTH-STROKE-1/2) (- HEIGHT-Y-1/4) 0.0))
                          (dir WIDTH-STROKE-1/2 HEIGHT-Y-1/4 DEPTH-Z-1/2))
               ; right connector x
               (rectangle (pos+ LINE/MEAN/END-3/4
                                (dir (- WIDTH-STROKE-1/2) HEIGHT-X-1/4 0.0))
                          (dir WIDTH-STROKE-1/2 HEIGHT-X-1/4 DEPTH-Z-1/2))
               ; bottom arc
               (cirque-x-3/4 #:arc (arc 0.0 (+ 90.0 UPPER-ARC-OFFSET))
                             #:basis 'x))
              (- WIDTH-STROKE WIDTH-EM-3/8))))))

(define char:E
  (make-Char-3D-memoized
   #\E
   WIDTH-EM-1/2
   (λ ()
     (combine
      ; left ascender
      (rectangle (pos+ LINE/MID/START +x WIDTH-STROKE-1/2)
                 (dir WIDTH-STROKE-1/2 HEIGHT-CAP-1/2 DEPTH-Z-1/2))
      ; top cross
      (rectangle (pos+ LINE/CAP/START
                       (dir (+ WIDTH-STROKE-1/2 WIDTH-BASE/WIDE-1/2) WIDTH-STROKE-1/2 0.0))
                 (dir WIDTH-BASE/WIDE-1/2 WIDTH-STROKE-1/2 DEPTH-Z-1/2))
      (rectangle (pos+ LINE/MEAN/START
                       (dir (+ WIDTH-STROKE-1/2 WIDTH-BASE/WIDE-1/2) 0.0 0.0))
                 (dir WIDTH-BASE/WIDE-1/2 WIDTH-STROKE-1/2 DEPTH-Z-1/2))
      (rectangle (pos+ LINE/BASE/START
                       (dir (+ WIDTH-STROKE-1/2 WIDTH-BASE/WIDE-1/2) (- WIDTH-STROKE-1/2) 0.0))
                 (dir WIDTH-BASE/WIDE-1/2 WIDTH-STROKE-1/2 DEPTH-Z-1/2))))))

(define char:F
  (make-Char-3D-memoized
   #\F
   WIDTH-EM-1/2
   (λ ()
     (combine
      ; left ascender
      (rectangle (pos+ LINE/MID/START +x WIDTH-STROKE-1/2)
                 (dir WIDTH-STROKE-1/2 HEIGHT-CAP-1/2 DEPTH-Z-1/2))
      ; top cross
      (rectangle (pos+ LINE/CAP/START
                       (dir (+ WIDTH-STROKE-1/2 WIDTH-BASE/WIDE-1/2) WIDTH-STROKE-1/2 0.0))
                 (dir WIDTH-BASE/WIDE-1/2 WIDTH-STROKE-1/2 DEPTH-Z-1/2))
      (rectangle (pos+ LINE/MEAN/START
                       (dir (+ WIDTH-STROKE-1/2 WIDTH-BASE/WIDE-1/2) 0.0 0.0))
                 (dir WIDTH-BASE/WIDE-1/2 WIDTH-STROKE-1/2 DEPTH-Z-1/2))))))

(define char:G
  (make-Char-3D-memoized
   #\G
   WIDTH-EM-5/8
   (λ ()
     (combine
      ; top arc
      (cirque-y-1/2 #:arc (arc -180.0 (- UPPER-ARC-OFFSET)) #:basis 'x)
      ; left connector y
      (rectangle (pos+ LINE/MEAN/START
                       (dir WIDTH-STROKE-1/2 (- HEIGHT-Y-1/4) 0.0))
                 (dir WIDTH-STROKE-1/2 HEIGHT-Y-1/4 DEPTH-Z-1/2))
      ; left connector x
      (rectangle (pos+ LINE/MEAN/START
                       (dir WIDTH-STROKE-1/2 HEIGHT-X-1/4 0.0))
                 (dir WIDTH-STROKE-1/2 HEIGHT-X-1/4 DEPTH-Z-1/2))
      ; bottom arc
      (cirque-x-1/2 #:arc (arc 0.0 180.0) #:basis 'x)
      ; right connector x
      (rectangle (pos+ LINE/MEAN/START
                       (dir (- WIDTH-EM-1/2 WIDTH-STROKE-1/2) HEIGHT-X-1/4 0.0))
                 (dir WIDTH-STROKE-1/2 HEIGHT-X-1/4 DEPTH-Z-1/2))
      ; center tab
      (rectangle (pos+ LINE/MEAN/START
                       (dir (- WIDTH-EM-1/2 WIDTH-STROKE-1/2 WIDTH-BASE/NARROW-1/2) WIDTH-STROKE-1/2 0.0))
                 (dir WIDTH-BASE/NARROW-1/2 WIDTH-STROKE-1/2 DEPTH-Z-1/2))))))

(define char:H
  (make-Char-3D-memoized
   #\H
   WIDTH-EM-5/8
   (λ ()
     (combine
      ; left ascender
      (rectangle (pos+ LINE/MID/START +x WIDTH-STROKE-1/2)
                 (dir WIDTH-STROKE-1/2 HEIGHT-CAP-1/2 DEPTH-Z-1/2))
      ; right ascender
      (rectangle (pos+ LINE/MID/END-1/2 -x WIDTH-STROKE-1/2)
                 (dir WIDTH-STROKE-1/2 HEIGHT-CAP-1/2 DEPTH-Z-1/2))
      ; cross
      (rectangle (pos+ LINE/MEAN/CENTER-1/2 +y WIDTH-STROKE-1/2)
                 (dir WIDTH-EM-1/4 WIDTH-STROKE-1/2 DEPTH-Z-1/2))))))

(define char:I
  (make-Char-3D-memoized
   #\I
   WIDTH-EM-5/8
   (λ ()
     (combine
      ; top cross
      (rectangle (pos+ LINE/CAP/CENTER-1/2 +y WIDTH-STROKE-1/2)
                 (dir WIDTH-EM-1/4 WIDTH-STROKE-1/2 DEPTH-Z-1/2))
      ; ascender
      (rectangle LINE/MID/CENTER-1/2
                 (dir WIDTH-STROKE-1/2 HEIGHT-CAP-1/2 DEPTH-Z-1/2))
      ; bottom cross
      (rectangle (pos+ LINE/BASE/CENTER-1/2 -y WIDTH-STROKE-1/2)
                 (dir WIDTH-EM-1/4 WIDTH-STROKE-1/2 DEPTH-Z-1/2))))))

(define char:J
  (make-Char-3D-memoized
   #\J
   WIDTH-EM-3/4
   (λ ()
     (combine
      ; top cross
      (rectangle (pos+ LINE/CAP/END-1/2
                       (dir (- 0.0 WIDTH-STROKE-1/2 WIDTH-BASE/NARROW-1/2) WIDTH-STROKE-1/2 0.0))
                 (dir WIDTH-BASE/NARROW-1/2 WIDTH-STROKE-1/2 DEPTH-Z-1/2))
      ; ascender y
      (rectangle (pos+ LINE/MID-Y/END-1/2
                       (dir (- WIDTH-STROKE-1/2) 0.0 0.0))
                 (dir WIDTH-STROKE-1/2 HEIGHT-Y-1/2 DEPTH-Z-1/2))
      ; ascender x
      (rectangle (pos+ LINE/MEAN/END-1/2
                       (dir (- WIDTH-STROKE-1/2) HEIGHT-X-1/4 0.0))
                 (dir WIDTH-STROKE-1/2 HEIGHT-X-1/4 DEPTH-Z-1/2))
      ; bottom arc
      (cirque-x-link-1/2 #:arc (arc 0.0 (- 180.0 UPPER-ARC-OFFSET)) #:basis 'x)))))

(define char:K
  (make-Char-3D-memoized
   #\K
   WIDTH-EM-5/8
   (λ ()
     (combine
      ; ascender
      (rectangle (pos+ LINE/MID/START +x WIDTH-STROKE-1/2)
                 (dir WIDTH-STROKE-1/2 HEIGHT-CAP-1/2 DEPTH-Z-1/2))
      ; arm
      (quad-thicc (pos+ LINE/CAP/END-3/8
                        (dir WIDTH-STROKE                         0.0 0.0))
                  (pos+ LINE/CAP/END-3/8
                        (dir 0.0 0.0 0.0))
                  (pos+ LINE/MEAN/START
                        (dir WIDTH-STROKE                         0.0 0.0))
                  (pos+ LINE/MEAN/START
                        (dir (+ WIDTH-STROKE WIDTH-STROKE) WIDTH-STROKE-1/4 0.0)))
      ; leg
      (move-x (combine (cirque-x-3/4 #:arc (arc -90.0 0.0) #:basis 'x)
                       (rectangle (pos+ LINE/BASE/END-3/4
                                        (dir (- WIDTH-STROKE-1/2) (- HEIGHT-X-1/4) 0.0))
                                  (dir WIDTH-STROKE-1/2 HEIGHT-X-1/4 DEPTH-Z-1/2)))
              (- WIDTH-STROKE WIDTH-EM-3/8))))))

(define char:L
  (make-Char-3D-memoized
   #\L
   WIDTH-EM-1/2
   (λ ()
     (combine
      ; left ascender
      (rectangle (pos+ LINE/MID/START +x WIDTH-STROKE-1/2)
                 (dir WIDTH-STROKE-1/2 HEIGHT-CAP-1/2 DEPTH-Z-1/2))
      ; base
      (rectangle (pos+ LINE/BASE/START
                       (dir (+ WIDTH-STROKE-1/2 WIDTH-BASE/WIDE-1/2) (- WIDTH-STROKE-1/2) 0.0))
                 (dir WIDTH-BASE/WIDE-1/2 WIDTH-STROKE-1/2 DEPTH-Z-1/2))))))

(define char:M
  (make-Char-3D-memoized
   #\M
   WIDTH-EM-7/8
   (λ () (combine
          ; ascender left
          (rectangle (pos+ LINE/MID/START +x WIDTH-STROKE-1/2)
                     (dir WIDTH-STROKE-1/2 HEIGHT-CAP-1/2 DEPTH-Z-1/2))
          ; left diagonal
          (quad-thicc (pos+ LINE/MEAN/CENTER-3/4 -x WIDTH-STROKE-1/2)
                      (pos+ LINE/MEAN/CENTER-3/4 +x WIDTH-STROKE-1/2)
                      (pos+ LINE/CAP/START   +x WIDTH-STROKE)
                      (pos+ LINE/CAP/START   +x 0.0))
          ; right diagonal
          (quad-thicc (pos+ LINE/MEAN/CENTER-3/4 -x WIDTH-STROKE-1/2)
                      (pos+ LINE/MEAN/CENTER-3/4 +x WIDTH-STROKE-1/2)
                      (pos+ LINE/CAP/END-3/4     -x 0.0)
                      (pos+ LINE/CAP/END-3/4     -x WIDTH-STROKE))
          ; ascender right
          (rectangle (pos+ LINE/MID/END-3/4 -x WIDTH-STROKE-1/2)
                     (dir WIDTH-STROKE-1/2 HEIGHT-CAP-1/2 DEPTH-Z-1/2))))))

(define char:N
  (make-Char-3D-memoized
   #\N
   WIDTH-EM-5/8
   (λ () (combine
          ; ascender left
          (rectangle (pos+ LINE/MID/START +x WIDTH-STROKE-1/2)
                     (dir WIDTH-STROKE-1/2 HEIGHT-CAP-1/2 DEPTH-Z-1/2))
          ; diagonal
          (quad-thicc (pos+ LINE/BASE/END-1/2 -x WIDTH-DIAGONAL-BASE)
                      (pos+ LINE/BASE/END-1/2 +x 0.0)
                      (pos+ LINE/CAP/START    +x WIDTH-DIAGONAL-BASE)
                      (pos+ LINE/CAP/START    +x 0.0))
          ; ascender right
          (rectangle (pos+ LINE/MID/END-1/2 -x WIDTH-STROKE-1/2)
                     (dir WIDTH-STROKE-1/2 HEIGHT-CAP-1/2 DEPTH-Z-1/2))))))

(define char:O
  (make-Char-3D-memoized
   #\O
   WIDTH-EM-5/8
   (λ ()
     (combine
      ; arc top
      (cirque-y-1/2 #:arc (arc -180.0 0.0) #:basis 'x)
      ; connector left y
      (rectangle (pos+ LINE/MEAN/START
                       (dir WIDTH-STROKE-1/2 (- HEIGHT-Y-1/4) 0.0))
                 (dir WIDTH-STROKE-1/2 HEIGHT-Y-1/4 DEPTH-Z-1/2))
      ; connector left x
      (rectangle (pos+ LINE/MEAN/START
                       (dir WIDTH-STROKE-1/2 HEIGHT-X-1/4 0.0))
                 (dir WIDTH-STROKE-1/2 HEIGHT-X-1/4 DEPTH-Z-1/2))
      ; arc bottom
      (cirque-x-1/2 #:arc (arc 0.0 180.0) #:basis 'x)
      ; connector right x
      (rectangle (pos+ LINE/MEAN/END-1/2
                       (dir (- WIDTH-STROKE-1/2) HEIGHT-X-1/4 0.0))
                 (dir WIDTH-STROKE-1/2 HEIGHT-X-1/4 DEPTH-Z-1/2))
      ; connector right y
      (rectangle (pos+ LINE/MEAN/END-1/2
                       (dir (- WIDTH-STROKE-1/2) (- HEIGHT-Y-1/4) 0.0))
                 (dir WIDTH-STROKE-1/2 HEIGHT-Y-1/4 DEPTH-Z-1/2))))))

(define char:P
  (make-Char-3D-memoized
   #\P
   WIDTH-EM-5/8
   (λ ()
     (define overangle 15.0)
     (combine
      ; ascender
      (rectangle (pos+ LINE/MID/START +x WIDTH-STROKE-1/2)
                 (dir WIDTH-STROKE-1/2 HEIGHT-CAP-1/2 DEPTH-Z-1/2))
      ; loop
      (move-x (cirque-y-3/4 #:arc (arc (- -90.0 overangle) (+ 90.0 overangle))
                            #:basis 'y)
              (- WIDTH-STROKE WIDTH-EM-3/8))))))

(define char:Q
  (make-Char-3D-memoized
   #\Q
   WIDTH-EM-5/8
   (λ ()
     (define arc-bottom-radius-x WIDTH-EM-1/4)
     (define arc-bottom-radius-y HEIGHT-X-1/2)
     (define arc-bottom-center (pos+ LINE/MID-X/START +x arc-bottom-radius-x))
     (define tail-top-angle (degrees->radians 40.0))
     (define tail-bottom-angle (degrees->radians 70.0))
     (combine
      ; arc top
      (cirque-y-1/2 #:arc (arc -180.0 0.0) #:basis 'x)
      ; connector left y
      (rectangle (pos+ LINE/MEAN/START
                       (dir WIDTH-STROKE-1/2 (- HEIGHT-Y-1/4) 0.0))
                 (dir WIDTH-STROKE-1/2 HEIGHT-Y-1/4 DEPTH-Z-1/2))
      ; connector left x
      (rectangle (pos+ LINE/MEAN/START
                       (dir WIDTH-STROKE-1/2 HEIGHT-X-1/4 0.0))
                 (dir WIDTH-STROKE-1/2 HEIGHT-X-1/4 DEPTH-Z-1/2))
      ; arc bottom
      (cirque-x-1/2 #:arc (arc 0.0 180.0) #:basis 'x)
      ; connector right x
      (rectangle (pos+ LINE/MEAN/END-1/2
                       (dir (- WIDTH-STROKE-1/2) HEIGHT-X-1/4 0.0))
                 (dir WIDTH-STROKE-1/2 HEIGHT-X-1/4 DEPTH-Z-1/2))
      ; connector right y
      (rectangle (pos+ LINE/MEAN/END-1/2
                       (dir (- WIDTH-STROKE-1/2) (- HEIGHT-Y-1/4) 0.0))
                 (dir WIDTH-STROKE-1/2 HEIGHT-Y-1/4 DEPTH-Z-1/2))
      ; tail
      (quad-thicc (pos+ arc-bottom-center
                        (dir (* arc-bottom-radius-x (cos tail-top-angle))
                             (* arc-bottom-radius-y (sin tail-top-angle))
                             0.0))
                  (pos+ arc-bottom-center
                        (dir (* arc-bottom-radius-x (cos tail-bottom-angle))
                             (* arc-bottom-radius-y (sin tail-bottom-angle))
                             0.0))
                  (pos+ LINE/BASE/CENTER-3/4
                        (dir WIDTH-STROKE-1/2 (+ HEIGHT-DESC-1/4 WIDTH-STROKE-1/4) 0.0))
                  (pos+ LINE/BASE/CENTER-3/4
                        (dir WIDTH-STROKE     (- HEIGHT-DESC-1/4 WIDTH-STROKE-1/4) 0.0)))))))

(define char:R
  (make-Char-3D-memoized
   #\R
   WIDTH-EM-5/8
   (λ ()
     (define overangle 15.0)
     (combine
      ; ascender
      (rectangle (pos+ LINE/MID/START +x WIDTH-STROKE-1/2)
                 (dir WIDTH-STROKE-1/2 HEIGHT-CAP-1/2 DEPTH-Z-1/2))
      ; loop
      (move-x (cirque-y-3/4 #:arc (arc (- -90.0 overangle) (+ 90.0 overangle))
                            #:basis 'y)
              (- WIDTH-STROKE WIDTH-EM-3/8))
      ; leg
      (quad-thicc (pos+ LINE/MEAN/START
                        (dir (+ WIDTH-STROKE WIDTH-STROKE) (- WIDTH-STROKE-1/4) 0.0))
                  (pos+ LINE/MEAN/START
                        (dir WIDTH-STROKE                         0.0 0.0))
                  (pos+ LINE/BASE/END-3/8
                        (dir (- WIDTH-STROKE WIDTH-DIAGONAL-BASE) 0.0 0.0))
                  (pos+ LINE/BASE/END-3/8
                        (dir WIDTH-STROKE                         0.0 0.0)))))))

(define char:S
  (make-Char-3D-memoized
   #\S
   WIDTH-EM-5/8
   (λ () (combine
          ; upper
          (cirque-y-1/2 #:arc (arc  90.0 330.0) #:basis 'y)
          ; lower
          (cirque-x-link-1/2 #:arc (arc -90.0 -210.0) #:basis 'y)))))

(define char:T
  (make-Char-3D-memoized
   #\T
   WIDTH-EM-5/8
   (λ ()
     (combine
      ; top cross
      (rectangle (pos+ LINE/CAP/CENTER-1/2 +y WIDTH-STROKE-1/2)
                 (dir WIDTH-EM-1/4 WIDTH-STROKE-1/2 DEPTH-Z-1/2))
      ; ascender
      (rectangle LINE/MID/CENTER-1/2
                 (dir WIDTH-STROKE-1/2 HEIGHT-CAP-1/2 DEPTH-Z-1/2))))))

(define char:U
  (make-Char-3D-memoized
   #\U
   WIDTH-EM-5/8
   (λ ()
     (combine
      ; ascender left y
      (rectangle (pos+ LINE/MID-Y/START
                       (dir WIDTH-STROKE-1/2 WIDTH-STROKE-1/2 0.0))
                 (dir WIDTH-STROKE-1/2 HEIGHT-Y-1/2 DEPTH-Z-1/2))
      ; ascender left x
      (rectangle (pos+ LINE/MEAN/START
                       (dir WIDTH-STROKE-1/2 HEIGHT-X-1/4 0.0))
                 (dir WIDTH-STROKE-1/2 HEIGHT-X-1/4 DEPTH-Z-1/2))
      ; arc bottom
      (cirque-x-1/2 #:arc (arc 0.0 180.0) #:basis 'x)
      ; ascender right x
      (rectangle (pos+ LINE/MEAN/END-1/2
                       (dir (- WIDTH-STROKE-1/2) HEIGHT-X-1/4 0.0))
                 (dir WIDTH-STROKE-1/2 HEIGHT-X-1/4 DEPTH-Z-1/2))
      ; ascender right y
      (rectangle (pos+ LINE/MID-Y/END-1/2
                       (dir (- WIDTH-STROKE-1/2) WIDTH-STROKE-1/2 0.0))
                 (dir WIDTH-STROKE-1/2 HEIGHT-Y-1/2 DEPTH-Z-1/2))))))

(define char:V
  (make-Char-3D-memoized
   #\V
   WIDTH-EM-5/8
   (λ () (combine
          ; left
          (quad-thicc (pos+ LINE/BASE/CENTER-1/2 -x WIDTH-STROKE-1/2)
                      (pos+ LINE/BASE/CENTER-1/2 +x WIDTH-STROKE-1/2)
                      (pos+ LINE/CAP/START       +x WIDTH-STROKE)
                      (pos+ LINE/CAP/START       +x 0.0))
          ; right
          (quad-thicc (pos+ LINE/BASE/CENTER-1/2 -x WIDTH-STROKE-1/2)
                      (pos+ LINE/BASE/CENTER-1/2 +x WIDTH-STROKE-1/2)
                      (pos+ LINE/CAP/END-1/2     -x 0.0)
                      (pos+ LINE/CAP/END-1/2     -x WIDTH-STROKE))))))

(define char:W
  (make-Char-3D-memoized
   #\W
   WIDTH-EM-7/8
   (λ ()
     (define center-offset WIDTH-EM-3/8)
     (define bottom-offset WIDTH-BASE/NARROW)
     (define far (+ center-offset center-offset))
     (define farbottom (- far bottom-offset))
     (combine
      ; left
      (quad-thicc (pos+ LINE/CAP/START  +x WIDTH-STROKE)
                  (pos+ LINE/CAP/START  +x 0.0)
                  (pos+ LINE/BASE/START +x (- bottom-offset WIDTH-STROKE-1/2))
                  (pos+ LINE/BASE/START +x (+ bottom-offset WIDTH-STROKE-1/2)))
      ; center left
      (quad-thicc (pos+ LINE/BASE/START +x (- bottom-offset WIDTH-STROKE-1/2))
                  (pos+ LINE/BASE/START +x (+ bottom-offset WIDTH-STROKE-1/2))
                  (pos+ LINE/MEAN/START +x (+ center-offset WIDTH-STROKE-1/2))
                  (pos+ LINE/MEAN/START +x (- center-offset WIDTH-STROKE-1/2)))
      ; center right
      (quad-thicc (pos+ LINE/MEAN/START +x (+ center-offset WIDTH-STROKE-1/2))
                  (pos+ LINE/MEAN/START +x (- center-offset WIDTH-STROKE-1/2))
                  (pos+ LINE/BASE/START +x (- farbottom WIDTH-STROKE-1/2))
                  (pos+ LINE/BASE/START +x (+ farbottom WIDTH-STROKE-1/2)))
      ; right
      (quad-thicc (pos+ LINE/BASE/START +x (- farbottom WIDTH-STROKE-1/2))
                  (pos+ LINE/BASE/START +x (+ farbottom WIDTH-STROKE-1/2))
                  (pos+ LINE/CAP/START  +x far)
                  (pos+ LINE/CAP/START  +x (- far WIDTH-STROKE)))))))

(define char:X
  (make-Char-3D-memoized
   #\X
   WIDTH-EM-9/16
   (λ ()
     (combine
      ; bottom-left to top-right
      (quad-thicc (pos+ LINE/BASE/START   +x 0.0)
                  (pos+ LINE/BASE/START   +x WIDTH-STROKE)
                  (pos+ LINE/CAP/END-1/2 -x 0.0)
                  (pos+ LINE/CAP/END-1/2 -x WIDTH-STROKE))
      ; bottom-right to top-left
      (quad-thicc (pos+ LINE/BASE/END-1/2 -x WIDTH-STROKE)
                  (pos+ LINE/BASE/END-1/2 -x 0.0)
                  (pos+ LINE/CAP/START   +x WIDTH-STROKE)
                  (pos+ LINE/CAP/START   +x 0.0))))))

(define char:Y
  (make-Char-3D-memoized
   #\Y
   WIDTH-EM-5/8
   (λ ()
     (combine
      ; left
      (quad-thicc (pos+ LINE/MEAN/CENTER-1/2 -x WIDTH-STROKE-1/2)
                  (pos+ LINE/MEAN/CENTER-1/2 +x WIDTH-STROKE-1/2)
                  (pos+ LINE/CAP/START       +x WIDTH-STROKE)
                  (pos+ LINE/CAP/START       +x 0.0))
      ; right
      (quad-thicc (pos+ LINE/MEAN/CENTER-1/2 -x WIDTH-STROKE-1/2)
                  (pos+ LINE/MEAN/CENTER-1/2 +x WIDTH-STROKE-1/2)
                  (pos+ LINE/CAP/END-1/2     -x 0.0)
                  (pos+ LINE/CAP/END-1/2     -x WIDTH-STROKE))
      (rectangle LINE/MID-X/CENTER-1/2
                 (dir WIDTH-STROKE-1/2 HEIGHT-X-1/2 DEPTH-Z-1/2))))))

(define char:Z
  (make-Char-3D-memoized
   #\Z
   WIDTH-EM-5/8
   (λ ()
     (combine
      ; top
      (rectangle (pos+ LINE/CAP/CENTER-1/2 +y WIDTH-STROKE-1/2)
                 (dir WIDTH-EM-1/4 WIDTH-STROKE-1/2 DEPTH-Z-1/2))
      ; diagonal
      (quad-thicc (pos+ LINE/BASE/START   (dir 0.0              (- WIDTH-STROKE) 0.0))
                  (pos+ LINE/BASE/START   (dir WIDTH-STROKE     (- WIDTH-STROKE) 0.0))
                  (pos+ LINE/CAP/END-1/2  (dir 0.0              WIDTH-STROKE     0.0))
                  (pos+ LINE/CAP/END-1/2  (dir (- WIDTH-STROKE) WIDTH-STROKE     0.0)))
      ; top
      (rectangle (pos+ LINE/BASE/CENTER-1/2 -y WIDTH-STROKE-1/2)
                 (dir WIDTH-EM-1/4 WIDTH-STROKE-1/2 DEPTH-Z-1/2))))))
