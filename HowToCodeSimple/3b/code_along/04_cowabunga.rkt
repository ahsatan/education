;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname 04_cowabunga) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Cows are docile creatures. They stay inside the fence, walking back and forth nicely.
; 
; Design a world program with the following behaviour:
;    - A cow walks back and forth across the screen.
;    - When the nose of the cow reaches an edge it changes direction and goes back
;      the other way.
;    - When you start the program it should be possible to control how fast a
;      walker your cow is.
;    - Pressing space makes it change direction right away.
; 
; Once your program works here is something you can try for fun. If you rotate the
; images of the cow slightly, and you vary the image you use as the cow moves, you
; can make it appear as if the cow is waddling as it walks across the screen.
; 
; .
; 


(require 2htdp/image)
(require 2htdp/universe)
(define Image (signature (predicate image?)))
(define KeyEvent (signature (predicate key-event?)))

(define WIDTH 400)
(define HEIGHT 200)
(define CTR-Y (/ HEIGHT 2))
(define MTS (empty-scene WIDTH HEIGHT "midnight blue"))
(define L-COW .)
(define R-COW .)
(define CENTER-COW-X (/ (image-width L-COW) 2))
(define L-EDGE (+ 0 CENTER-COW-X))
(define R-EDGE (- WIDTH CENTER-COW-X))


;; (CowOf (Natural(L-EDGE, R-EDGE) Integer))
(define-struct cow (x dx))
;; interp. X-position and velocity of the cow
;;         - x is the center of the cow
;;         - negative dx moves left, positive moves right at the given pixels/tick

(define C1 (make-cow 45 3))
(define C2 (make-cow 132 -4))

#;
(define (fn-for-cow c)
  (... (cow-x c)
       (cow-dx c)))


(: main (Cow -> Cow))
;; Render a cow walking back and forth on a background.
;; Start with (main (make-cow L-EDGE 3)).
(define (main c)
  (big-bang c
    (on-tick advance-cow)
    (to-draw render)
    (on-key handle-key)))


(: advance-cow (Cow -> Cow))
;; Produce the cow's next position, changing direction if the cow's nose is touching the edge.

(check-expect (advance-cow (make-cow (+ R-EDGE -3) 3)) (make-cow R-EDGE 3))
(check-expect (advance-cow (make-cow R-EDGE 3)) (make-cow R-EDGE -3))
(check-expect (advance-cow (make-cow (/ WIDTH 2) 3)) (make-cow (+ (/ WIDTH 2) 3) 3))
(check-expect (advance-cow (make-cow (+ L-EDGE 3) -3)) (make-cow L-EDGE -3))
(check-expect (advance-cow (make-cow L-EDGE -3)) (make-cow L-EDGE 3))
(check-expect (advance-cow (make-cow (/ WIDTH 2) -3)) (make-cow (+ (/ WIDTH 2) -3) -3))

(define (advance-cow c)
  (cond [(> (+ (cow-x c) (cow-dx c)) R-EDGE) (make-cow R-EDGE (- (cow-dx c)))]
        [(< (+ (cow-x c) (cow-dx c)) L-EDGE) (make-cow L-EDGE (- (cow-dx c)))]
        [else (make-cow (+ (cow-x c) (cow-dx c)) (cow-dx c))]))


(: render (Cow -> Image))
;; Produce an image of a cow at the given x-coordinate moving in the given direction.

(check-expect (render (make-cow L-EDGE 4)) (place-image R-COW L-EDGE CTR-Y MTS))
(check-expect (render (make-cow (/ WIDTH 2) -4)) (place-image L-COW (/ WIDTH 2) CTR-Y MTS))

(define (render c)
  (place-image (choose-image c) (cow-x c) CTR-Y MTS))


(: choose-image (Cow -> Image))
;; Produce left or right-facing cow depending on cow's direction.

(check-expect (choose-image (make-cow L-EDGE 4)) R-COW)
(check-expect (choose-image (make-cow (/ WIDTH 2) -4)) L-COW)

(define (choose-image c)
  (if (positive? (cow-dx c)) R-COW L-COW))


(: handle-key (Cow KeyEvent -> Cow))
;; Flip the cow's direction when pressing spacebar.

(check-expect (handle-key (make-cow R-EDGE -1) " ") (make-cow R-EDGE 1))
(check-expect (handle-key (make-cow R-EDGE -1) "a") (make-cow R-EDGE -1))

(define (handle-key c ke)
  (if (key=? " " ke)
      (make-cow (cow-x c) (- (cow-dx c)))
      c))


#;
(main (make-cow L-EDGE 3))