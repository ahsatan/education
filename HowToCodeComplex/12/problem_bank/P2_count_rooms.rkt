;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname P2_count_rooms) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
; 
; PROBLEM
; 
; Design a function that consumes a room and produces the total number of rooms reachable
; from the given room. Include the starting room itself. Use tail recursion.
; 
; Do NOT use the primitive length function.
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


(: num-rooms (Room -> Natural))
;; Produce the number of rooms reachable from and including the given room.

(check-expect (num-rooms R1) 2)
(check-expect (num-rooms R2) 2)
(check-expect (num-rooms R3) 3)
(check-expect (num-rooms R4) 6)

(define (num-rooms r)
  ;; todo: (ListOf Room) is worklist accumulator of rooms to still act on
  ;; visited: (ListOf String) is names of rooms already visited
  (local [(define (--room r todo visited total)
            (if (member (room-name r) visited)
                (--lor todo visited total)
                (--lor (append (room-exits r) todo) (cons (room-name r) visited) (add1 total))))

          (define (--lor todo visited total)
            (cond [(empty? todo) total]
                  [else (--room (first todo) (rest todo) visited total)]))]
    (--room r empty empty 0)))