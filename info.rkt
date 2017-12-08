#lang info
(define collection "m4p")
(define deps '("base"
               "typed-racket-lib"
               "typed-racket-more"
               "draw-lib"
               "rackunit-lib"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/m4p.scrbl" ())))
(define pkg-desc "A simple utility to download and play music")
(define version "0.0.1")
(define pkg-authors '(sourav))
