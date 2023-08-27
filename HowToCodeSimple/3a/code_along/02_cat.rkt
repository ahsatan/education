;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname 02_cat) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Follow HtDW to design an interactive program in which a cat starts at
; the left edge of the display and walks across the screen to the right.
; The cat should keep moving right off the screen.
; 
; Pressing the space key should cause the cat to move to the left edge of the screen.
; 
; Use the image below:
; 
; .
; 
; Initial Domain Analysis:
; 
; .
; 


(require 2htdp/image)
(require 2htdp/universe)
(define Image (signature (predicate image?)))
(define MouseEvent (signature (predicate mouse-event?)))
(define KeyEvent (signature (predicate key-event?)))

(define WIDTH 600)
(define HEIGHT 400)
(define MTS (empty-scene WIDTH HEIGHT "midnight blue"))
(define CENTER-Y (/ HEIGHT 2))
(define CAT .)
(define SPEED 3)

(define CatX (signature Natural))
;; interp. Cat's x-position in screen coordinates.

(define CX1 0)
(define CX2 228)

#;
(define (fn-for-cat-x cx)
  (... cx))


(: main (CatX -> CatX))
;; Render a cat moving across a background from left to right.
;; Start with (main 0).
(define (main cx)
  (big-bang cx
    (on-tick advance-cat)
    (to-draw render)
    (on-mouse handle-mouse)
    (on-key handle-key)))


(: advance-cat (CatX -> CatX))
;; Produce next incremental x-position of cat.

(check-expect (advance-cat 0) (+ SPEED 0))

(define (advance-cat cx)
  (+ SPEED cx))


(: render (CatX -> Image))
;; Produce image of cat at the given x-position on MTS.

(check-expect (render 4) (place-image CAT 4 CENTER-Y MTS))

(define (render cx)
  (place-image CAT cx CENTER-Y MTS))


(: handle-mouse (CatX Integer Integer MouseEvent -> CatX))
;; Set cat's x-position to the mouse's x-position on click.

(check-expect (handle-mouse 159 23 77 "button-down") 23)
(check-expect (handle-mouse 159 23 77 "enter") 159)

(define (handle-mouse cx x y m)
  (cond [(mouse=? "button-down" m) x]
        [else cx]))


(: handle-key (CatX KeyEvent -> CatX))
;; Reset cat's x-position when pressing spacebar.

(check-expect (handle-key 120 " ") 0)
(check-expect (handle-key 27 "a") 27)
(check-expect (handle-key 0 " ") 0)

(define (handle-key cx k)
  (cond [(key=? " " k) 0]
        [else cx]))


#;
(main 0)