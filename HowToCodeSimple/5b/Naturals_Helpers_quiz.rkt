;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname Naturals_Helpers_quiz) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(define Image (signature (predicate image?)))

(define COOKIES .)


;; Natural is one of:
;; - 0
;; - (add1 Natural)
;; interp. A natural number.
(define N0 0)
(define N1 (add1 N0))
(define N2 (add1 N1))

#;
(define (fn-for-natural n)
  (cond [(zero? n) ...]
        [else (... n           
                   (fn-for-natural (sub1 n)))]))


; 
; PROBLEM A
; 
; Complete the design of a function called pyramid that takes a natural
; number n and an image, and constructs an n-tall, n-wide pyramid of
; copies of that image.
; 
; For instance, a 3-wide pyramid of cookies would look like this:
; 
; .
; 


(: pyramid (Natural Image -> Image))
;; Produce an n-wide pyramid of the given image.

(check-expect (pyramid 0 COOKIES) empty-image)
(check-expect (pyramid 1 COOKIES) COOKIES)
(check-expect (pyramid 3 COOKIES)
              (above COOKIES
                     (beside COOKIES COOKIES)
                     (beside COOKIES COOKIES COOKIES)))

(define (pyramid n i)
  (cond [(zero? n) empty-image]
        [else (above (pyramid (sub1 n) i)
                     (row n i))]))

(: row (Natural Image -> Image))
;; Produce an n-wide row of the given image, n > 0.

(check-expect (row 1 COOKIES) COOKIES)
(check-expect (row 3 COOKIES) (beside COOKIES COOKIES COOKIES))

(define (row n i)
  (cond [(= 1 n) COOKIES]
        [else (beside COOKIES (row (sub1 n) i))]))


; 
; PROBLEM B
; 
; Consider a test tube filled with solid blobs and bubbles.  Over time the
; solids sink to the bottom of the test tube, and as a consequence the bubbles
; percolate to the top.  Let's capture this idea in BSL.
; 
; Complete the design of a function that takes a list of blobs and sinks each
; solid blob by one. It's okay to assume that a solid blob sinks past any
; neighbor just below it.
; 


(define SOLID "solid")
(define BUBBLE "bubble")

(define Blob (signature (enum SOLID BUBBLE)))
;; interp. A gelatinous blob, either solid or bubble.

#;
(define (fn-for-blob b)
  (cond [(string=? b SOLID) ...]
        [(string=? b BUBBLE) ...]))


;; (ListOf Blob): one of
;; - empty
;; - (cons Blob (ListOf Blob))
;; interp. A sequence of blobs in a test tube, listed from top to bottom.
(define LOB0 empty)
(define LOB2 (cons SOLID (cons BUBBLE empty)))

#;
(define (fn-for-lob lob)
  (cond [(empty? lob) ...]
        [else (... (fn-for-blob (first lob))
                   (fn-for-lob (rest lob)))]))


(: sink ((ListOf Blob) -> (ListOf Blob)))
;; Produce a list of blobs that sinks the given solid blobs by one.

(check-expect (sink empty) empty)
(check-expect (sink (cons BUBBLE (cons SOLID (cons BUBBLE empty))))
              (cons BUBBLE (cons BUBBLE (cons SOLID empty))))
(check-expect (sink (cons SOLID (cons SOLID (cons BUBBLE empty))))
              (cons BUBBLE (cons SOLID (cons SOLID empty))))
(check-expect (sink (cons SOLID (cons BUBBLE (cons BUBBLE empty))))
              (cons BUBBLE (cons SOLID (cons BUBBLE empty))))
(check-expect (sink (cons SOLID (cons BUBBLE (cons SOLID empty))))
              (cons BUBBLE (cons SOLID (cons SOLID empty))))
(check-expect (sink (cons BUBBLE (cons SOLID (cons SOLID empty))))
              (cons BUBBLE (cons SOLID (cons SOLID empty))))
(check-expect (sink (cons SOLID (cons SOLID (cons BUBBLE (cons BUBBLE empty)))))
              (cons BUBBLE (cons SOLID (cons SOLID (cons BUBBLE empty)))))

(define (sink lob)
  (cond [(empty? lob) empty]
        [(empty? (rest lob)) lob]
        [else (if (string=? SOLID (first lob))
                  (cons (first (sink (rest lob)))
                        (cons (first lob)
                              (rest (sink (rest lob)))))
                  (cons (first lob) (sink (rest lob))))]))