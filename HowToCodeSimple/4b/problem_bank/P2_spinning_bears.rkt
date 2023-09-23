;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P2_spinning_bears) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; This world is about spinning bears. The world will start with an empty screen. Clicking
; anywhere on the screen will cause a bear to appear at that spot. The bear starts out upright,
; but then rotates counterclockwise at a constant speed. Each time the mouse is clicked on the 
; screen, a new upright bear appears and starts spinning.
; 
; So each bear has its own x and y position, as well as its angle of rotation. And there are an
; arbitrary amount of bears.
; 
; To start, design a world that has only one spinning bear. Initially, the world will start
; with one bear spinning in the center at the screen. Clicking the mouse at a spot on the
; world will replace the old bear with a new bear at the new spot. You can do this part 
; with only material up through compound. 
; 
; Once this is working you should expand the program to include an arbitrary number of bears.
; 


(require 2htdp/image)
(require 2htdp/universe)
(define Image (signature (predicate image?)))
(define MouseEvent (signature (predicate mouse-event?)))
(define KeyEvent (signature (predicate key-event?)))

(define BEAR .)
(define WIDTH 1600)
(define HEIGHT 960)
(define MTS (empty-scene WIDTH HEIGHT "midnight blue"))
(define ROT-SPEED 3)


;; (BearOf Natural Natural Natural)
;; interp. Location and rotational angle of a bear on screen.
(define-struct bear (x y rot))

(define B1 (make-bear 0 0 0))
(define B2 (make-bear 223 64 359))

#;
(define (fn-for-bear b)
  (... (bear-x b)
       (bear-y b)
       (bear-rot b)))


;; (ListOf Bear): one of
;; - empty
;; - (cons Bear (ListOf Bear))

(define LOB1 empty)
(define LOB2 (cons B1 empty))
(define LOB3 (cons B2 (cons B1 empty)))

#;
(define (fn-for-lob lob)
  (cond [(empty? lob) ...]
        [else (... (first lob)
                   (fn-for-lob (rest lob)))]))


(: main ((ListOf Bear) -> (ListOf Bear)))
;; Produce a scene of spinning bears.
;; Start with (main empty).
(define (main lob)
  (big-bang lob
    (on-tick tock)
    (to-draw render-lob)
    (on-mouse handle-mouse)
    (on-key handle-key)))


(: tock ((ListOf Bear) -> (ListOf Bear)))
;; Increase the rotation of each bear.

(check-expect (tock empty) empty)
(check-expect (tock LOB2) (cons (tock-bear B1) empty))
(check-expect (tock LOB3) (cons (tock-bear B2) (cons (tock-bear B1) empty)))

(define (tock lob)
  (cond [(empty? lob) empty]
        [else (cons (tock-bear (first lob))
                    (tock (rest lob)))]))


(: tock-bear (Bear -> Bear))
;; Increase the rotation of a single bear.

(check-expect (tock-bear B2) (make-bear (bear-x B2) (bear-y B2) (+ (bear-rot B2) ROT-SPEED)))

(define (tock-bear b)
  (make-bear (bear-x b)
             (bear-y b)
             (+ ROT-SPEED (bear-rot b))))


(: render-lob ((ListOf Bear) -> Image))
;; Render the list of rotated bears in a scene.

(check-expect (render-lob LOB1) MTS)
(check-expect (render-lob LOB2)
              (place-image (rotate-bear B1) (bear-x B1) (bear-y B1) MTS))
(check-expect (render-lob LOB3)
              (place-image (rotate-bear B2) (bear-x B2) (bear-y B2)
                           (place-image (rotate-bear B1) (bear-x B1) (bear-y B1)
                                        MTS)))

(define (render-lob lob)
  (cond [(empty? lob) MTS]
        [else (place-image (rotate-bear (first lob)) (bear-x (first lob)) (bear-y (first lob))
                           (render-lob (rest lob)))]))


(: rotate-bear (Bear -> Image))
;; Produce a rotated single bear.

(check-expect (rotate-bear B2) (rotate (modulo (bear-rot B2) 360) BEAR))

(define (rotate-bear b)
  (rotate (modulo (bear-rot b) 360) BEAR))


(: handle-mouse ((ListOf Bear) Integer Integer MouseEvent -> (ListOf Bear)))
;; On click, add a bear at the current location.

(check-expect (handle-mouse empty 10 10 "button-up") empty)
(check-expect (handle-mouse empty 10 10 "button-down") (cons (make-bear 10 10 0) empty))
(check-expect (handle-mouse LOB2 20 20 "button-down") (cons (make-bear 20 20 0) LOB2))

(define (handle-mouse lob x y me)
  (cond [(mouse=? me "button-down") (cons (make-bear x y 0) lob)]
        [else lob]))


(: handle-key ((ListOf Bear) KeyEvent -> (ListOf Bear)))
;; On space, reset scene to have no bears.

(check-expect (handle-key LOB2 " ") empty)
(check-expect (handle-key LOB2 "a") LOB2)

(define (handle-key lob ke)
  (cond [(key=? ke " ") empty]
        [else lob]))


(main empty)