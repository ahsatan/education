;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname 01_graphs) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
; 
; PROBLEM
; 
; Imagine you are suddenly transported into a mysterious house, in which all
; you can see is the name of the room you are in, and any doors that lead OUT
; of the room.  One of the things that makes the house so mysterious is that
; the doors only go in one direction. You can't see the doors that lead into
; the room.
; 
; Here are some examples of such a house:
; 
; ; .
;    ; .
;    ; .
;     ; .
; 
; 
; In computer science, we refer to such an information structure as a directed
; graph. Like trees, in directed graphs the arrows have direction. But in a
; graph it is  possible to go in circles, as in the second example above. It
; is also possible for two arrows to lead into a single node, as in the fourth
; example.
;    
; Design a data definition to represent such houses. Also provide example data
; for the four houses above.
; 


;; (RoomOf String (ListOf Room))
(define-struct room (name exits))
;; interp. A room in house with exit-only doors.

(define R1 (make-room "A" (list (make-room "B" empty))))
(define R2 (shared ([-0- (make-room "A" (list (make-room "B" (list -0-))))])
             -0-))
(define R3 (shared ([A (make-room "A" (list B))]
                    [B (make-room "B" (list C))]
                    [C (make-room "C" (list A))])
             A))
(define R4 (shared ([A (make-room "A" (list B D))]
                    [B (make-room "B" (list C E))]
                    [C (make-room "C" (list B))]
                    [D (make-room "D" (list E))]
                    [E (make-room "E" (list A F))]
                    [F (make-room "F" empty)])
             A))

;; Mutual structural recursion in local, tail recursion, worklist, context-preserving accumulator
#;
(define (fn-for-room r)
  ;; todo: (ListOf Room) is worklist accumulator of rooms to still act on
  ;; visited: (ListOf String) is names of rooms already visited
  (local [(define (--room r todo visited)
            (if (member (room-name r) visited)
                (--lor todo visited)
                (--lor (append (room-exits r) todo) (cons (room-name r) visited))))

          (define (--lor todo visited)
            (cond [(empty? todo) ...]
                  [else (--room (first todo) (rest todo) visited)]))]
    (--room r empty empty)))


(: reachable? (Room String -> Boolean))
;; Produce #true if it is possible to reach room with given name from given starting room.

(check-expect (reachable? R1 "A") #t)
(check-expect (reachable? R1 "B") #t)
(check-expect (reachable? R1 "C") #f)
(check-expect (reachable? (first (room-exits R1)) "A") #f)
(check-expect (reachable? R4 "F") #t)

(define (reachable? r n)
  ;; todo: (ListOf Room) is worklist accumulator of rooms to still act on
  ;; visited: (ListOf String) is names of rooms already visited
  (local [(define (--room r todo visited)
            (cond [(string=? n (room-name r)) #t]
                  [(member (room-name r) visited) (--lor todo visited)]
                  [else (--lor (append (room-exits r) todo) (cons (room-name r) visited))]))

          (define (--lor todo visited)
            (cond [(empty? todo) #f]
                  [else (--room (first todo) (rest todo) visited)]))]
    (--room r empty empty)))