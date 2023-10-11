;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname 01_fractals) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(define Image (signature (predicate image?)))

; 
; PROBLEM
; 
; Design a function that consumes a number and produces a Sierpinski
; triangle of that size. Your function should use generative recursion.
; 
; One way to draw a Sierpinski triangle is to:
; 
;  - start with an equilateral triangle with side length s
;  
;      .
;      
;  - inside that triangle are three more Sierpinski triangles
;      
;  - and inside each of those... and so on
;  
; So that you end up with something that looks like this:
;    
; 
;    
; 
; .
;    
; Note that in the 2nd picture above the inner triangles are drawn in 
; black and slightly smaller just to make them clear. In the real
; Sierpinski triangle they should be in the same color and of side
; length s/2. Also note that the center upside down triangle is not
; an explicit triangle, it is simply formed from the other triangles.
; 


(define TRI-MIN 4)

(: s-tri (Number -> Image))
;; Produce a Sierpinski triangle of the given size.

(check-expect (s-tri TRI-MIN) (triangle TRI-MIN "outline" "gold"))
(check-expect (s-tri (* TRI-MIN 2)) (overlay (triangle (* TRI-MIN 2) "outline" "gold")
                                             (local [(define sub (s-tri TRI-MIN))]
                                               (above sub
                                                      (beside sub sub)))))

(define (s-tri n)
  (cond [(<= n TRI-MIN) (triangle n "outline" "gold")]
        [else (overlay (triangle n "outline" "gold")
                       (local [(define sub (s-tri (/ n 2)))]
                         (above sub
                                (beside sub sub))))]))

#;
(sierpinski 256)


; 
; PROBLEM
; 
; Design a function to produce a Sierpinski carpet of size s.
; 
; Here is an example of a larger Sierpinski carpet.
; 
; .
; 


(define CAR-MIN 3)

(: s-car (Number -> Image))
;; Produce a Sierpinski carpet of the given size.

(check-expect (s-car CAR-MIN) (square CAR-MIN "outline" "gold"))
(check-expect (s-car (* CAR-MIN 3))
              (overlay (square (* CAR-MIN 3) "outline" "gold")
                       (local [(define sub (s-car CAR-MIN))
                               (define blank (square CAR-MIN "solid" "black"))]
                         (above (beside sub sub sub)
                                (beside sub blank sub)
                                (beside sub sub sub)))))

(define (s-car n)
  (cond [(<= n CAR-MIN) (square n "outline" "gold")]
        [else (overlay (square n "outline" "gold")
                       (local [(define sub (s-car (/ n 3)))
                               (define blank (square (/ n 3) "solid" "black"))]
                         (above (beside sub sub sub)
                                (beside sub blank sub)
                                (beside sub sub sub))))]))

#;
(s-car 243)

#;
(s-car 270)
