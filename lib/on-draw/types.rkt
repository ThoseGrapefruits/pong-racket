#lang typed/racket/base

(require pict3d)

(provide (struct-out Score-Section)
         SCORE-SECTIONS)

(define-struct Score-Section
  ([color-emitted : Emitted]
   [y : Flonum]
   [place-low : Integer]
   [place-high : Integer]))

(define SCORE-SECTIONS : (Listof Score-Section)
  (list (Score-Section (emitted 1.0 1.0 1.0 2.0) 0.0  10       1)   ; ones
        (Score-Section (emitted 0.5 0.7 1.0 2.0) 0.03 100     10)   ; tens
        (Score-Section (emitted 1.0 0.8 0.0 2.0) 0.06 1000   100)   ; hundreds
        (Score-Section (emitted 1.3 1.0 2.0 1.5) 0.09 10000 1000))) ; thousands