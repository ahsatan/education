;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P1_render_roster) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; You are running a dodgeball tournament and are given a list of all
; of the players in a particular game as well as their team numbers.  
; You need to build a game roster like the one shown below. We've given
; you some constants and data definitions for Player, ListOfPlayer 
; and ListOfString to work with. 
; 
; While you're working on these problems, make sure to keep your 
; helper rules in mind and use helper functions when necessary.
; 
; .
; 


(require 2htdp/image)
(define Image (signature (predicate image?)))

(define CELL-WIDTH 200)
(define CELL-HEIGHT 30)
(define TEXT-SIZE 20)
(define COLOR "gold")


;; (PlayerOf String Natural[1, 2])
(define-struct player (name team))
;; interp. A dodgeball player.
 
(define P0 (make-player "Samael" 1))
(define P1 (make-player "Georgia" 2))
(define P2 (make-player "Amanda" 1))

#;
(define (fn-for-player p)
  (... (player-name p)
       (player-team p)))


;; (ListOf Player): one of
;; - empty
;; - (cons Player (ListOf Player))
;; interp.  A list of dodgeball players.
(define LOP0 empty)
(define LOP1 (cons P0 empty))
(define LOP2 (cons P1 LOP1))
(define LOP3 (cons P2 LOP2))

#;
(define (fn-for-lop lop)
  (cond [(empty? lop) ...]
        [else (... (fn-for-player (first lop))
                   (fn-for-lop (rest lop)))]))


;; (ListOf String): one of
;; - empty
;; - (cons String (ListOf String))
;; interp. A list of strings.
(define LOS0 empty)
(define LOS1 (cons "Samael" empty))
(define LOS2 (cons "Georgia" LOS1))

#;
(define (fn-for-los los)
  (cond [(empty? los) ...]
        [else (... (first los)
                   (fn-for-los (rest los)))]))


; 
; PROBLEM A
; 
; Design a function called select-players that consumes a list 
; of players and a team t (Natural[1,2]) and produces a list of 
; player names that are on team t.
; 


(: select-players ((ListOf Player) Natural -> (ListOf String)))
;; Produce the list of player names on the given team where team is [1, 2].

(check-expect (select-players LOP0 1) empty)
(check-expect (select-players LOP1 2) empty)
(check-expect (select-players LOP2 1) (cons "Samael" empty))
(check-expect (select-players LOP2 2) (cons "Georgia" empty))
(check-expect (select-players LOP3 1) (cons "Amanda" (cons "Samael" empty)))

(define (select-players lop t)
  (cond [(empty? lop) empty]
        [else (if (=  t (player-team (first lop)))
                  (cons (player-name (first lop)) (select-players (rest lop) t))
                  (select-players (rest lop) t))]))


; 
; PROBLEM B
; 
; Complete the design of render-roster. We've started you off with 
; the signature, purpose, stub and examples. You'll need to use
; the function that you designed in Problem 1.
; 
; Note that we've also given you a full function design for render-los
; and its helper, render-cell. You will need to use these functions
; when solving this problem.
; 


(: render-roster ((ListOf Player) -> Image))
;; Render a game roster from the given list of players.

(check-expect (render-roster empty)
              (beside/align 
               "top"
               (overlay
                (text "Team 1" TEXT-SIZE COLOR)
                (rectangle CELL-WIDTH CELL-HEIGHT "outline" COLOR))
               (overlay
                (text "Team 2" TEXT-SIZE COLOR)
                (rectangle CELL-WIDTH CELL-HEIGHT "outline" COLOR))))
(check-expect (render-roster LOP2)
              (beside/align 
               "top"
               (above
                (overlay
                 (text "Team 1" TEXT-SIZE COLOR)
                 (rectangle CELL-WIDTH CELL-HEIGHT "outline" COLOR))
                (overlay
                 (text "Samael" TEXT-SIZE COLOR)
                 (rectangle CELL-WIDTH CELL-HEIGHT "outline" COLOR)))
               (above
                (overlay
                 (text "Team 2" TEXT-SIZE COLOR)
                 (rectangle CELL-WIDTH CELL-HEIGHT "outline" COLOR))
                (overlay
                 (text "Georgia" TEXT-SIZE COLOR)
                 (rectangle CELL-WIDTH CELL-HEIGHT "outline" COLOR)))))

(define (render-roster lop)
  (beside/align "top"
                (render-los (cons "Team 1" (select-players lop 1)))
                (render-los (cons "Team 2" (select-players lop 2)))))


(: render-los ((ListOf String) -> Image))
;; Render a list of strings as a column of cells.

(check-expect (render-los empty) empty-image)
(check-expect (render-los (cons "Samael" empty))
              (above 
               (overlay
                (text "Samael" TEXT-SIZE COLOR)
                (rectangle CELL-WIDTH CELL-HEIGHT "outline" COLOR))
               empty-image))
(check-expect (render-los (cons "Samael" (cons "Brigid" empty)))
              (above
               (overlay
                (text "Samael" TEXT-SIZE COLOR)
                (rectangle CELL-WIDTH CELL-HEIGHT "outline" COLOR))
               (overlay
                (text "Brigid" TEXT-SIZE COLOR)
                (rectangle CELL-WIDTH CELL-HEIGHT "outline" COLOR))
               empty-image))

(define (render-los los)
  (cond [(empty? los) empty-image]
        [else
         (above (render-cell (first los))
                (render-los (rest los)))]))


(: render-cell (String -> Image))
;; Render a cell of the game table
(check-expect (render-cell "Team 1") 
              (overlay
               (text "Team 1" TEXT-SIZE COLOR)
               (rectangle CELL-WIDTH CELL-HEIGHT "outline" COLOR)))

(define (render-cell s)
  (overlay
   (text s TEXT-SIZE COLOR)
   (rectangle CELL-WIDTH CELL-HEIGHT "outline" COLOR)))