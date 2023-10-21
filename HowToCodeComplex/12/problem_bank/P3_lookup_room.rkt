;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname P3_lookup_room) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
; 
; PROBLEM
; 
; Design a function that consumes a room and a room name and tries to find a room with
; the given name starting at the given room.
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


(: lookup-room (Room String -> (mixed Room Boolean)))
;; Produce room with the given name if findable from the given room, otherwise #false.

(check-expect (lookup-room R1 "A") R1)
(check-expect (lookup-room R1 "B") (make-room "B" empty))
(check-expect (lookup-room R1 "C") #f)
(check-expect (lookup-room R4 "F") (make-room "F" empty))
(check-expect (lookup-room R4 "E") (shared ([A (make-room "A" (list B D))]
                                            [B (make-room "B" (list C E))]
                                            [C (make-room "C" (list B))]
                                            [D (make-room "D" (list E))]
                                            [E (make-room "E" (list A F))]
                                            [F (make-room "F" empty)])
                                     E))

(define (lookup-room r n)
  ;; todo: (ListOf Room) is worklist accumulator of rooms to still act on
  ;; visited: (ListOf String) is names of rooms already visited
  (local [(define (--room r todo visited)
            (cond [(string=? n (room-name r)) r]
                  [(member (room-name r) visited) (--lor todo visited)]
                  [else (--lor (append (room-exits r) todo) (cons (room-name r) visited))]))

          (define (--lor todo visited)
            (cond [(empty? todo) #f]
                  [else (--room (first todo) (rest todo) visited)]))]
    (--room r empty empty)))