;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname P4_max_exits) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
; 
; PROBLEM
; 
; Design a function that produces the room with the most exits
; (in the case of a tie you can produce any of the rooms in the tie).
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


(: most-exits (Room -> Room))
;; Produce the room with the most exits.

(check-expect (most-exits R1) R1)
(check-expect (most-exits R2) (shared ([A (make-room "A" (list B))]
                                       [B (make-room "B" (list A))])
                                A))
(check-expect (most-exits (shared ([A (make-room "A" (list B))]
                                   [B (make-room "B" (list A C))]
                                   [C (make-room "C" (list A))])
                            A))
              (shared ([A (make-room "A" (list B))]
                       [B (make-room "B" (list A C))]
                       [C (make-room "C" (list A))])
                B))
(check-expect (most-exits (shared ([A (make-room "A" (list B D))]
                                   [B (make-room "B" (list C E))]
                                   [C (make-room "C" (list B))]
                                   [D (make-room "D" (list E))]
                                   [E (make-room "E" (list A C F))]
                                   [F (make-room "F" empty)])
                            A))
              (shared ([A (make-room "A" (list B D))]
                       [B (make-room "B" (list C E))]
                       [C (make-room "C" (list B))]
                       [D (make-room "D" (list E))]
                       [E (make-room "E" (list A C F))]
                       [F (make-room "F" empty)])
                E))

(define (most-exits r)
  ;; todo: (ListOf Room) is worklist accumulator of rooms to still act on
  ;; visited: (ListOf String) is names of rooms already visited
  (local [(define (--room r todo visited res)
            (if (member (room-name r) visited)
                (--lor todo visited res)
                (--lor (append (room-exits r) todo) (cons (room-name r) visited) (more-exits r res))))

          (define (more-exits r res)
            (if (> (length (room-exits r)) (length (room-exits res)))
                r
                res))

          (define (--lor todo visited res)
            (cond [(empty? todo) res]
                  [else (--room (first todo) (rest todo) visited res)]))]
    (--room r empty empty r)))