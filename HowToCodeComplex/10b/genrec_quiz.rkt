;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname genrec_quiz) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require racket/list)
(require 2htdp/image)
(define Image (signature (predicate image?)))

; 
; PROBLEM 1
;  
; Here is a geometric fractal that is made of circles:
;  
;  .
;  
; Design a function to create this circle fractal.
;  


(define CUT-OFF 5)

(: fractal (Number String -> Image))
;; Produce a circle fractal of size n and color c.
;; ASSUME: n > 0.

(check-expect (fractal 5 "gold") (circle 5 "outline" "gold"))
(check-expect (fractal 8 "gold") (overlay (circle 8 "outline" "gold")
                                          (beside (circle 4 "outline" "gold")
                                                  (circle 4 "outline" "gold"))))

(define (fractal n c)
  (cond [(<= n CUT-OFF) (circle n "outline" c)]
        [else (local [(define sub (fractal (/ n 2) c))]
                (overlay (circle n "outline" c)
                         (beside sub sub)))]))


; 
; PROBLEM 2
; 
; Design a function that produces all possible filled boards reachable from the current board.
; 
; Filter out boards that are impossible if X and O are alternating turns.
; 
; You can assume X plays first, so all valid boards will have 5 Xs and 4 Os.
; 
; You can assume that the players keep placing Xs and Os after someone has won.
;  


(define E #f)
(define X "X")
(define O "O")

(define Square (signature (enum X O E)))
;; interp. A square is either empty (E) or X or O.

#;
(define (fn-for-square v)
  (cond [(false? v) (...)]
        [(string=? v X) (...)]
        [(string=? v O) (...)]))

(define Board (signature (ListOf Square)))
;; interp. Board is a list of 9 Squares.

(define B0 (list E E E
                 E E E
                 E E E))

(define B1 (list E X O     ; a partly finished board
                 O X O
                 E E X)) 

(define B2 (list X O O     ; a board where X will win
                 O X O
                 X E X))

(define B3 (list X O X     ; a board where O will win
                 O O E
                 X X E))

#;
(define (fn-for-board b)
  (cond [(empty? b) (...)]
        [else 
         (... (fn-for-value (first b))
              (fn-for-board (rest b)))]))


(: fill-square (Board Natural Square -> Board))
;; Produce new board with given Square at given position.

(check-expect (fill-square B2 7 X)
              (list X O O
                    O X O
                    X X X))
(check-expect (fill-square B2 7 O)
              (list X O O
                    O X O
                    X O X))

(define (fill-square b p sq)
  (append (take b p)
          (list sq)
          (drop b (add1 p))))


(: gen-boards (Board -> (ListOf Board)))
;; Produce the list of all possible boards from the given starting board.

(check-expect (gen-boards B3) (list (list X O X
                                          O O X
                                          X X O)
                                    (list X O X
                                          O O O
                                          X X X)))

(define (gen-boards b)
  (local [(define (gen-all b)
            (cond [(full? b) (list b)]
                  [else (local [(define next-e (find-e b))]
                          (append (gen-boards (fill-square b next-e X))
                                  (gen-boards (fill-square b next-e O))))]))

          (define (valid? b)
            (= (diff b) 1))

          (define (diff b)
            (cond [(empty? b) 0]
                  [(false? (first b)) 0]
                  [else (if (string=? X (first b))
                            (add1 (diff (rest b)))
                            (sub1 (diff (rest b))))]))]
    (filter valid? (gen-all b))))


(: full? (Board -> Boolean))
;; Produce #true if all the board's squares are either X or O.

(check-expect (full? B2) #f)
(check-expect (full? (fill-square B2 7 X)) #t)

(define (full? b)
  (andmap string? b))


(: find-e (Board -> Natural))
;; Produce the next empty position in the board.
;; ASSUME: Board is not full.

(check-expect (find-e B2) 7)

(define (find-e b)
  (if (false? (first b))
      0
      (add1 (find-e (rest b)))))