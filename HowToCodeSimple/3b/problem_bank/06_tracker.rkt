;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname 06_tracker) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM:
; 
; Design a world program that displays the current (x, y) position
; of the mouse at that current position. As the mouse moves the 
; numbers in the (x, y) display changes and its position changes. 
; 


(require 2htdp/image)
(require 2htdp/universe)
(define Image (signature (predicate image?)))
(define Mouse-Event (signature (predicate mouse-event?)))

(define HEIGHT 300)
(define WIDTH 400)
(define MTS (empty-scene WIDTH HEIGHT "midnight blue"))
(define FONT-SZ 24)
(define TEXT-CLR "yellow")

;; (PosOf (Natural Natural))
(define-struct pos (x y))
;; interp. x and y coordinates of a point on a screen

(define P1 (make-pos 3 27))
(define P2 (make-pos 199 64))

#;
(define (fn-for-pos p)
  (... (pos-x p)
       (pos-y p)))


(: main (Pos -> Pos))
;; Produce a text image describing the mouse's position on the background scene.
;; Start with (main (make-pos 0 0)).
(define (main p)
  (big-bang p
    (to-draw render)
    (on-mouse handle-mouse)))


(: render (Pos -> Image))
;; Draw the given coordinate position as a text image on the background scene.

(check-expect (render P1)
              (place-image (text (format "(~a, ~a)" (pos-x P1) (pos-y P1)) FONT-SZ TEXT-CLR)
                           (pos-x P1)
                           (pos-y P1)
                           MTS))

(define (render p)
  (place-image (text (format "(~a, ~a)" (pos-x p) (pos-y p))
                     FONT-SZ
                     TEXT-CLR)
               (pos-x p)
               (pos-y p)
               MTS))


(: handle-mouse (Pos Integer Integer Mouse-Event -> Pos))
;; Update the position to the current mouse's position on any mouse movement.

(check-expect (handle-mouse P1 11 22 "move") (make-pos 11 22))
(check-expect (handle-mouse P1 11 22 "button-up") P1)

(define (handle-mouse p x y me)
  (if (mouse=? "move" me)
      (make-pos x y)
      p))



(main (make-pos 0 0))