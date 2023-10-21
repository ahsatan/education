;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname P1_all_reachable) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
; 
; PROBLEM
; 
; a) Design a function that consumes a room and produces a list of the names of
;    all the rooms reachable from that room.
; 
; b) Revise your function from (a) so that it produces a list of the rooms
;    not the room names.
; 


;; (RoomOf String (ListOf Room))
(define-struct room (name exits))
;; interp. A room in house with exit-only doors.

; .
 
(define R1 (make-room "A" (list (make-room "B" empty))))

; .
 
(define R2 (shared ([-0- (make-room "A" (list (make-room "B" (list -0-))))])
             -0-))

; .

(define R3 (shared ([A (make-room "A" (list B))]
                    [B (make-room "B" (list C))]
                    [C (make-room "C" (list A))])
             A))

; .

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


(: names (Room -> (ListOf String)))
;; Produce the list of unique room names starting at the given room.

(check-expect (names R1) (list "A" "B"))
(check-expect (names R2) (list "A" "B"))
(check-expect (names R3) (list "A" "B" "C"))
(check-expect (names R4) (list "A" "B" "D" "C" "E" "F"))

(define (names r)
  ;; todo: (ListOf Room) is worklist accumulator of rooms to still act on
  ;; visited: (ListOf String) is names of rooms already visited
  (local [(define (--room r todo visited)
            (if (member (room-name r) visited)
                (--lor todo visited)
                (--lor (append todo (room-exits r)) (append visited (list (room-name r))))))

          (define (--lor todo visited)
            (cond [(empty? todo) visited]
                  [else (--room (first todo) (rest todo) visited)]))]
    (--room r empty empty)))


(: rooms (Room -> (ListOf Room)))
;; Produce the list of unique rooms starting at the given room.

(check-expect (rooms R1) (shared ([A (make-room "A" (list B))]
                                  [B (make-room "B" empty)])
                           (list A B)))
(check-expect (rooms R2) (shared ([A (make-room "A" (list B))]
                                  [B (make-room "B" (list A))])
                           (list A B)))
(check-expect (rooms R3) (shared ([A (make-room "A" (list B))]
                                 [B (make-room "B" (list C))]
                                 [C (make-room "C" (list A))])
                          (list A B C)))
(check-expect (rooms R4) (shared ([A (make-room "A" (list B D))]
                                  [B (make-room "B" (list C E))]
                                  [C (make-room "C" (list B))]
                                  [D (make-room "D" (list E))]
                                  [E (make-room "E" (list A F))]
                                  [F (make-room "F" empty)])
                           (list A B D C E F)))

(define (rooms r)
  ;; todo: (ListOf Room) is worklist accumulator of rooms to still act on
  ;; visited: (ListOf Room) is rooms already visited
  (local [(define (--room r todo visited)
            (if (member r visited)
                (--lor todo visited)
                (--lor (append todo (room-exits r)) (append visited (list r)))))

          (define (--lor todo visited)
            (cond [(empty? todo) visited]
                  [else (--room (first todo) (rest todo) visited)]))]
    (--room r empty empty)))