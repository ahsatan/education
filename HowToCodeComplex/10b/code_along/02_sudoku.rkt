;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname 02_sudoku) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require racket/list)

;; Brute Force Sudoku Solver

(define Val (signature (enum 1 2 3 4 5 6 7 8 9 #f)))
(define Board (signature (ListOf Val)))
;; interp. 9x9 (81 Val long) Sudoku Board.

(define Pos (signature Natural))
;; interp. Position on the board from 0 to 80.
;;   - row is    (quotient p 9)
;;   - column is (remainder p 9)


(: r-c->pos (Natural Natural -> Pos))
;; Convert 0-based row and column to Pos.
(define (r-c->pos r c) (+ (* r 9) c))

(define Unit (signature (ListOf Pos)))
;; interp. One of 27 groups of 9 Pos: row, column, or box.


(define ALL-VALS (list 1 2 3 4 5 6 7 8 9))

(define B #f)

(define BD1 
  (list B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B))

(define BD2 
  (list 1 2 3 4 5 6 7 8 9 
        B B B B B B B B B 
        B B B B B B B B B 
        B B B B B B B B B 
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B))

(define BD3 
  (list 1 B B B B B B B B
        2 B B B B B B B B
        3 B B B B B B B B
        4 B B B B B B B B
        5 B B B B B B B B
        6 B B B B B B B B
        7 B B B B B B B B
        8 B B B B B B B B
        9 B B B B B B B B))

(define BD4                ; easy
  (list 2 7 4 B 9 1 B B 5
        1 B B 5 B B B 9 B
        6 B B B B 3 2 8 B
        B B 1 9 B B B B 8
        B B 5 1 B B 6 B B
        7 B B B 8 B B B 3
        4 B 2 B B B B B 9
        B B B B B B B 7 B
        8 B B 3 4 9 B B B))

(define BD4s               ; solution to 4
  (list 2 7 4 8 9 1 3 6 5
        1 3 8 5 2 6 4 9 7
        6 5 9 4 7 3 2 8 1
        3 2 1 9 6 4 7 5 8
        9 8 5 1 3 7 6 4 2
        7 4 6 2 8 5 9 1 3
        4 6 2 7 5 8 1 3 9
        5 9 3 6 1 2 8 7 4
        8 1 7 3 4 9 5 2 6))

(define BD5                ; hard
  (list 5 B B B B 4 B 7 B
        B 1 B B 5 B 6 B B
        B B 4 9 B B B B B
        B 9 B B B 7 5 B B
        1 8 B 2 B B B B B 
        B B B B B 6 B B B 
        B B 3 B B B B B 8
        B 6 B B 8 B B B 9
        B B 8 B 7 B B 3 1))

(define BD5s               ; solution to 5
  (list 5 3 9 1 6 4 8 7 2
        8 1 2 7 5 3 6 9 4
        6 7 4 9 2 8 3 1 5
        2 9 6 4 1 7 5 8 3
        1 8 7 2 3 5 9 4 6
        3 4 5 8 9 6 1 2 7
        9 2 3 5 4 1 7 6 8
        7 6 1 3 8 2 4 5 9
        4 5 8 6 7 9 2 3 1))

(define BD6                ; hardest ever? (Dr Arto Inkala)
  (list B B 5 3 B B B B B 
        8 B B B B B B 2 B
        B 7 B B 1 B 5 B B 
        4 B B B B 5 3 B B
        B 1 B B 7 B B B 6
        B B 3 2 B B B 8 B
        B 6 B 5 B B B B 9
        B B 4 B B B B 3 B
        B B B B B 9 7 B B))

(define BD7                 ; no solution 
  (list 1 2 3 4 5 6 7 8 B 
        B B B B B B B B 2 
        B B B B B B B B 3 
        B B B B B B B B 4 
        B B B B B B B B 5
        B B B B B B B B 6
        B B B B B B B B 7
        B B B B B B B B 8
        B B B B B B B B 9))

(define ROWS
  (list (list  0  1  2  3  4  5  6  7  8)
        (list  9 10 11 12 13 14 15 16 17)
        (list 18 19 20 21 22 23 24 25 26)
        (list 27 28 29 30 31 32 33 34 35)
        (list 36 37 38 39 40 41 42 43 44)
        (list 45 46 47 48 49 50 51 52 53)
        (list 54 55 56 57 58 59 60 61 62)
        (list 63 64 65 66 67 68 69 70 71)
        (list 72 73 74 75 76 77 78 79 80)))

(define COLS
  (list (list 0  9 18 27 36 45 54 63 72)
        (list 1 10 19 28 37 46 55 64 73)
        (list 2 11 20 29 38 47 56 65 74)
        (list 3 12 21 30 39 48 57 66 75)
        (list 4 13 22 31 40 49 58 67 76)
        (list 5 14 23 32 41 50 59 68 77)
        (list 6 15 24 33 42 51 60 69 78)
        (list 7 16 25 34 43 52 61 70 79)
        (list 8 17 26 35 44 53 62 71 80)))

(define BOXES
  (list (list  0  1  2  9 10 11 18 19 20)
        (list  3  4  5 12 13 14 21 22 23)
        (list  6  7  8 15 16 17 24 25 26)
        (list 27 28 29 36 37 38 45 46 47)
        (list 30 31 32 39 40 41 48 49 50)
        (list 33 34 35 42 43 44 51 52 53)
        (list 54 55 56 63 64 65 72 73 74)
        (list 57 58 59 66 67 68 75 76 77)
        (list 60 61 62 69 70 71 78 79 80)))

(define UNITS (append ROWS COLS BOXES))


(: read-square (Board Pos -> Val))
;; Produce value at given position on board.

(check-expect (read-square BD2 (r-c->pos 0 5)) 6)
(check-expect (read-square BD3 (r-c->pos 7 0)) 8)

(define (read-square bd p)
  (list-ref bd p))               


(: fill-square (Board Pos Val -> Board))
;; Produce new board with given val at given position.

(check-expect (fill-square BD1 (r-c->pos 0 0) 1)
              (cons 1 (rest BD1)))

(define (fill-square bd p nv)
  (append (take bd p)
          (list nv)
          (drop bd (add1 p))))


(: solve (Board -> (mixed Board Boolean)))
;; Solve a Sudoku board or produce #false if unsolvable.
;; ASSUME: Valid board (no dupes in any unit).

(check-expect (solve BD4) BD4s)
(check-expect (solve BD5) BD5s)
(check-expect (solve BD7) #f)

(define (solve b) ;; arbitrary-arity
  (local [(define (--b b)
            (if (solved? b) ;; gen recursion
                b
                (--lob (gen-subs b))))

          (define (--lob lob)
            (cond [(empty? lob) #f]
                  [else (local [(define found (--b (first lob)))]
                          (if (not (false? found)) ;; backtracking search
                              found
                              (--lob (rest lob))))]))]
    (--b b)))


(: gen-subs (Board -> (ListOf Board)))
;; Generate all valid sub-boards of the given board.
;; Find first open square, fill it with Natural[1, 9], filter out invalid boards.

(check-expect (gen-subs (cons 1 (rest BD1)))
              (list (append (list 1 2) (rest (rest BD1)))
                    (append (list 1 3) (rest (rest BD1)))
                    (append (list 1 4) (rest (rest BD1)))
                    (append (list 1 5) (rest (rest BD1)))
                    (append (list 1 6) (rest (rest BD1)))
                    (append (list 1 7) (rest (rest BD1)))
                    (append (list 1 8) (rest (rest BD1)))
                    (append (list 1 9) (rest (rest BD1)))))

(define (gen-subs b)
  (filter valid? (fill-blank b (find-blank b))))


(: find-blank (Board -> Pos))
;; Produce the first blank position in the board.
;; ASSUME: Incomplete board.

(check-expect (find-blank BD1) 0)
(check-expect (find-blank BD2) 9)

(define (find-blank b)
  (if (false? (first b))
      0
      (add1 (find-blank (rest b)))))


(: fill-blank (Board Pos -> (ListOf Board)))
;; Produce the list of sub-boards with the given position filled with Natural[1, 9].

(check-expect (fill-blank (cons 1 (rest BD1)) 1)
              (list (append (list 1 1) (rest (rest BD1)))
                    (append (list 1 2) (rest (rest BD1)))
                    (append (list 1 3) (rest (rest BD1)))
                    (append (list 1 4) (rest (rest BD1)))
                    (append (list 1 5) (rest (rest BD1)))
                    (append (list 1 6) (rest (rest BD1)))
                    (append (list 1 7) (rest (rest BD1)))
                    (append (list 1 8) (rest (rest BD1)))
                    (append (list 1 9) (rest (rest BD1)))))

(define (fill-blank b pos)
  (build-list 9 (λ (n) (fill-square b pos (add1 n)))))


(: valid? (Board -> Boolean))
;; Produce #true if the given board is valid (no dupes in any unit).

(check-expect (valid? BD1) #t)
(check-expect (valid? BD2) #t)
(check-expect (valid? BD3) #t)
(check-expect (valid? BD4) #t)
(check-expect (valid? (cons 2 (rest BD2))) #f)
(check-expect (valid? (cons 2 (rest BD3))) #f)
(check-expect (valid? (fill-square BD4 1 6)) #f)

(define (valid? b)
  (local [(define (u->lov p) (read-square b p))

          (define (no-dupes? lov)
            (cond [(empty? lov) #t]
                  [else (and (not (member (first lov) (rest lov)))
                             (no-dupes? (rest lov)))]))

          (define (valid-unit? u) (no-dupes? (filter number? (map u->lov u))))]
    (andmap valid-unit? UNITS)))


(: solved? (Board -> Boolean))
;; Produce #true if all the board's vals are filled, otherwise #false.
;; ASSUME: Valid board.

(check-expect (solved? BD4) #f)
(check-expect (solved? BD4s) #t)

(define (solved? b)
  (andmap number? b))