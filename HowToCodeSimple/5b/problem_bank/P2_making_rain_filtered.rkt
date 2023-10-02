;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P2_making_rain_filtered) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Design a simple interactive animation of rain falling down a screen. Wherever we click,
; a rain drop should be created and as time goes by it should fall. Over time the drops
; will reach the bottom of the screen and "fall off". You should filter these excess
; drops out of the world state - otherwise your program is continuing to tick and
; and draw them long after they are invisible.
; 
; In your design pay particular attention to the helper rules. In our solution we use
; these rules to split out helpers:
;   - function composition
;   - reference
;   - knowledge domain shift
; 


(require 2htdp/image)
(require 2htdp/universe)
(define Image (signature (predicate image?)))
(define MouseEvent (signature (predicate mouse-event?)))

(define WIDTH  300)
(define HEIGHT 300)
(define SPEED 1)
(define DROP (ellipse 4 8 "solid" "blue"))
(define OFF-SCREEN (+ HEIGHT (/ (image-height DROP) 2) (- SPEED)))
(define MTS (empty-scene WIDTH HEIGHT "midnight blue"))


;; (: DropOf Integer Integer)
(define-struct drop (x y))
;; interp. A raindrop on the screen, with x and y coordinates.

(define D1 (make-drop 10 30))

#;
(define (fn-for-drop d)
  (... (drop-x d) 
       (drop-y d)))


;; (ListOf Drop): one of
;;  - empty
;;  - (cons Drop (ListOf Drop))
;; interp. A list of drops.

(define LOD0 empty)
(define LOD2 (cons (make-drop 10 20) (cons (make-drop 3 6) empty)))

#;
(define (fn-for-lod lod)
  (cond [(empty? lod) ...]
        [else (... (fn-for-drop (first lod))
                   (fn-for-lod (rest lod)))]))


;; ((ListOf Drop) -> (ListOf Drop))
;; Start rain program by evaluating (main empty).
(define (main lod)
  (big-bang lod
    (on-mouse handle-mouse)
    (on-tick  next-drops)
    (to-draw  render-drops))) ; ListOfDrop -> Image


(: handle-mouse ((ListOf Drop) Integer Integer MouseEvent -> (ListOf Drop)))
;; If me is "button-down" add a new drop at that position.

(check-expect (handle-mouse empty 20 30 "button-up") empty)
(check-expect (handle-mouse empty 20 30 "button-down") (cons (make-drop 20 30) empty))
(check-expect (handle-mouse LOD2 20 30 "button-down") (cons (make-drop 20 30) LOD2))

(define (handle-mouse lod x y me)
  (cond [(mouse=? "button-down" me) (cons (make-drop x y) lod)]
        [else lod]))


(: next-drops ((ListOf Drop) -> (ListOf Drop)))
;; Produce filtered and ticked list of drops.

(check-expect (next-drops LOD2) (cons (make-drop 10 (+ SPEED 20))
                                      (cons (make-drop 3 (+ SPEED 6)) empty)))
(check-expect (next-drops (cons (make-drop 10 20) (cons (make-drop 20 OFF-SCREEN) empty)))
              (cons (make-drop 10 (+ SPEED 20)) empty))

(define (next-drops lod)
  (tick-drops (filter-drops lod)))


(: filter-drops ((ListOf Drop) -> (ListOf Drop)))
;; Filter drops that are going off screen.

(check-expect (filter-drops empty) empty)
(check-expect (filter-drops (cons (make-drop 10 OFF-SCREEN) empty)) empty)
(check-expect (filter-drops (cons (make-drop 10 (- OFF-SCREEN 1))
                                  (cons (make-drop 15 OFF-SCREEN) empty)))
              (cons (make-drop 10 (- OFF-SCREEN 1)) empty))
(check-expect (filter-drops (cons (make-drop 15 OFF-SCREEN) (cons (make-drop 10 20) empty)))
              (cons (make-drop 10 20) empty))

(define (filter-drops lod)
  (cond [(empty? lod) empty]
        [else (if (< (drop-y (first lod)) OFF-SCREEN)
                  (cons (first lod) (filter-drops (rest lod)))
                  (filter-drops (rest lod)))]))


(: tick-drops ((ListOf Drop) -> (ListOf Drop)))
;; Tick each drop down the screen.

(check-expect (tick-drops empty) empty)
(check-expect (tick-drops (cons (make-drop 10 20) empty)) (cons (make-drop 10 (+ SPEED 20)) empty))
(check-expect (tick-drops LOD2) (cons (make-drop 10 (+ SPEED 20))
                                      (cons (make-drop 3 (+ SPEED 6)) empty)))

(define (tick-drops lod)
  (cond [(empty? lod) empty]
        [else (cons (tick-drop (first lod))
                    (tick-drops (rest lod)))]))


(: tick-drop (Drop -> Drop))
;; Tick a single drop down the screen.

(check-expect (tick-drop (make-drop 10 20)) (make-drop 10 (+ SPEED 20)))

(define (tick-drop d)
  (make-drop (drop-x d) (+ SPEED (drop-y d))))


(: render-drops ((ListOf Drop) -> Image))
;; Render the drops onto MTS.

(check-expect (render-drops empty) MTS)
(check-expect (render-drops (cons (make-drop 10 20) empty)) (place-image DROP 10 20 MTS))
(check-expect (render-drops (cons (make-drop 10 20) (cons (make-drop 20 30) empty)))
              (place-image DROP 10 20 (place-image DROP 20 30 MTS)))

(define (render-drops lod)
  (cond [(empty? lod) MTS]
        [else (place-image DROP
                           (drop-x (first lod))
                           (drop-y (first lod))
                           (render-drops (rest lod)))]))


#;
(main empty)