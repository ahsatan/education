;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname 01_maze_2w) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; 
; In this problem set you will design a program to check whether a given simple maze is
; solvable.  Note that you are operating on VERY SIMPLE mazes, specifically:
; 
;    - all of your mazes will be square
;    - the maze always starts in the upper left corner and ends in the lower right corner
;    - at each move, you can only move down or right
; 
; Design a representation for mazes, and then design a function that consumes a maze and
; produces #true if the maze is solvable, #false otherwise.
; 
; Solvable means that it is possible to start at the upper left, and make it all the way to
; the lower right.  Your final path can only move down or right one square at a time. BUT, it
; is permissible to backtrack if you reach a dead end.
; 
; For example, the first three mazes below are solvable.  Note that the fourth is not solvable
; because it would require moving left. In this solver you only need to support moving down
; and right! Moving in all four directions introduces complications we are not yet ready for.
; 
; .   .   .   .
; 


(require racket/list)

(define P #t) ; Path
(define E #f) ; Empty
(define SIZE 5)
(define MAX-POS (sub1 (sqr SIZE)))


(define Pos (signature Natural))
;; interp. A position in the maze from 0 to MAX-POS.

(define Tile (signature (enum P E)))
;; interp. Single tile on a maze - either a path or empty space.

(define Maze (signature (ListOf Tile)))
;; interp. Maze board of tiles of SIZE x SIZE.

(define M1 (list P E E E E   ; Solvable
                 P P E P P
                 E P E E E
                 P P E E E
                 P P P P P))

(define M2 (list P P P P P   ; Solvable
                 P E E E P
                 P E E E P
                 P E E E P
                 P E E E P))

(define M3 (list P P P P P   ; Solvable
                 P E E E E
                 P E E E E
                 P E E E E
                 P P P P P))

(define M4 (list P P P P P   ; Unsolvable
                 P E E E P
                 P E P P P
                 P E P E E
                 E E P P P))


(: read-tile (Maze Pos -> Tile))
;; Produce tile at given position on board.

(check-expect (read-tile M1 5) P)
(check-expect (read-tile M1 1) E)

(define (read-tile m p)
  (list-ref m p))


(: solvable? (Maze -> Boolean))
;; Produce #true if there is a path from the upper-left corner to lower-right corner
;; ASSUME: Upper-left corner is a path tile.

(check-expect (solvable? M1) #t)
(check-expect (solvable? M2) #t)
(check-expect (solvable? M3) #t)
(check-expect (solvable? M4) #f)

(define (solvable? m)
  (local [(define (search p)
            (cond [(false? p) #f]      ; Invalid position
                  [(= MAX-POS p) #t]   ; Bottom-right corner
                  [else (or (search (move-r m p))
                            (search (move-d m p)))]))]
    (search 0)))


(: move-r (Maze Pos -> (mixed Pos Boolean)))
;; Produce the next move right or #false if it's an invalid move.

(check-expect (move-r M1 0) #f)
(check-expect (move-r M1 5) 6)
(check-expect (move-r M1 9) #f)

(define (move-r m p)
  (local [(define np (add1 p))]
    (if (and (> (modulo np SIZE) 0) (read-tile m np))  ; Valid move
        np
        #f)))


(: move-d (Maze Pos -> (mixed Pos Boolean)))
;; Produce the next move down or #false if it's an invalid move.

(check-expect (move-d M1 5) #f)
(check-expect (move-d M1 0) 5)
(check-expect (move-d M1 21) #f)
(check-expect (move-d M2 19) 24)

(define (move-d m p)
  (local [(define np (+ SIZE p))]
    (if (and (<= np MAX-POS) (read-tile m np))   ; Valid move
        np
        #f)))