;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname cross_product_quiz) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM 1
; 
; Suppose you have rosters for players on two opposing tennis team, and each
; roster is ordered by team rank, with the best player listed first. When both 
; teams play, the best players of each team play one another,
; and the second-best players play one another, and so on down the line. When
; one team has more players than the other, the lowest ranking players on
; the larger team do not play.
; 
; Design a function that consumes two rosters, and produces #true if all players 
; on both teams will play if the teams play each other.
; 


(define Player (signature (predicate string?)))
;; interp. Name of a tennis player.

(define P0 "Maria")
(define P2 "Serena")

#;
(define (fn-for-player p)
  (... p))


(define Roster (signature (ListOf Player)))
;; (ListOf Player): one of
;; - empty
;; - (cons Player (ListOf Player))
;; interp. Team roster ordered from best player to worst.

(define R0 empty)
(define R1 (list "Eugenie" "Gabriela" "Sharon" "Aleksandra"))
(define R2 (list "Maria" "Nadia" "Elena" "Anastasia" "Svetlana"))

#;
(define (fn-for-roster r)
  (cond [(empty? r) ...]
        [else (... (fn-for-player (first r))
                   (fn-for-roster (rest r)))]))


;; (MatchOf Player Player)
(define-struct match (p1 p2))
;; interp. A match between player p1 and player p2 with same team rank.

(define M0 (make-match "Eugenie" "Maria"))
(define M1 (make-match "Gabriela" "Nadia"))

#;
(define (fn-for-match m)
  (... (match-p1 m) (match-p2 m)))


;; (ListOf Match) is one of:
;; - empty
;; - (cons Match (ListOf Match))
;; interp. A list of matches between two teams

(define LOM0 empty)
(define LOM1 (list (make-match "Eugenie" "Maria")
                   (make-match "Gabriela" "Nadia")))

#;
(define (fn-for-lom lom)
  (cond [(empty? lom) ...]
        [else (... (fn-for-match (first lom))
                   (fn-for-lom (rest lom)))]))


(: matched? (Roster Roster -> Boolean))
;; Produce #true if the two rosters have the same number of players, otherwise #false.

(check-expect (matched? R0 R0) #t)
(check-expect (matched? R0 R1) #f)
(check-expect (matched? R1 R0) #f)
(check-expect (matched? R1 R1) #t)
(check-expect (matched? R1 R2) #f)
(check-expect (matched? R2 R1) #f)

(define (matched? r1 r2)
  (cond [(and (empty? r1) (empty? r2)) #t]
        [(or (empty? r1) (empty? r2)) #f]
        [else (matched? (rest r1) (rest r2))]))


; 
; PROBLEM 2
; 
; Now write a function that, given two teams, produces the list of tennis matches
; that will be played. 
; 
; Assume that this function will only be called if the function you designed above
; produces #true. In other words, you can assume the two teams have the same number
; of players. 
; 


(: matches (Roster Roster -> (ListOf Match)))
;; Produce a list of matches between the players of the two teams.
;; ASSUME: Teams have an equal number of players.

(check-expect (matches empty empty) empty)
(check-expect (matches (list "Amelia") (list "Beau")) (list (make-match "Amelia" "Beau")))
(check-expect (matches (list "Carl" "Donna") (list "Eugene" "Frederica"))
              (list (make-match "Carl" "Eugene") (make-match "Donna" "Frederica")))

(define (matches r1 r2)
  (cond [(empty? r1) empty]
        [else (cons (make-match (first r1) (first r2))
                    (matches (rest r1) (rest r2)))]))