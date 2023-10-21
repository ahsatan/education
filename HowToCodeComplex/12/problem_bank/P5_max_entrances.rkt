;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname P5_max_entrances) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
; 
; PROBLEM
; 
; Design a function that produces the room to which the greatest number of other rooms have exits
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


(: most-entr (Room -> Room))
;; Produce the room that has the most entrances from other rooms.

(check-expect (most-entr R1) (shared ([A (make-room "A" (list B))]
                                      [B (make-room "B" empty)])
                               B))
(check-expect (most-entr R2) (shared ([A (make-room "A" (list B))]
                                      [B (make-room "B" (list A))])
                               B))
(check-expect (most-entr (shared ([A (make-room "A" (list B C))]
                                  [B (make-room "B" (list C))]
                                  [C (make-room "C" (list A))])
                           A))
              (shared ([A (make-room "A" (list B C))]
                       [B (make-room "B" (list C))]
                       [C (make-room "C" (list A))])
                C))
(check-expect (most-entr (shared ([A (make-room "A" (list B D))]
                                  [B (make-room "B" (list C E))]
                                  [C (make-room "C" (list B E))]
                                  [D (make-room "D" (list E))]
                                  [E (make-room "E" (list A F))]
                                  [F (make-room "F" empty)])
                           A))
              (shared ([A (make-room "A" (list B D))]
                       [B (make-room "B" (list C E))]
                       [C (make-room "C" (list B E))]
                       [D (make-room "D" (list E))]
                       [E (make-room "E" (list A F))]
                       [F (make-room "F" empty)])
                E))

(define (most-entr r)
  ;; (EntrOf Room Natural): rooms and the number of entrances into it
  ;; todo: (ListOf Room) is worklist accumulator of rooms to still act on
  ;; visited: (ListOf String) is names of rooms already visited
  (local [(define-struct entr (room count))
          
          (define (--room r todo visited loe)
            (if (member (room-name r) visited)
                (--lor todo visited loe)
                (--lor (append (room-exits r) todo)
                       (cons (room-name r) visited)
                       (update-loe loe (room-exits r)))))

          (define (--lor todo visited loe)
            (cond [(empty? todo) (entr-room (get-most loe))]
                  [else (--room (first todo) (rest todo) visited loe)]))

          (define (update-loe loe lor)
            (cond [(empty? lor) loe]
                  [else (update-loe (update-e loe (first lor)) (rest lor))]))
          
          (define (update-e loe r)
            (cond [(empty? loe) (list (make-entr r 1))]
                  [(string=? (room-name (entr-room (first loe))) (room-name r))
                   (cons (make-entr r (add1 (entr-count (first loe)))) (rest loe))]
                  [else (cons (first loe) (update-e (rest loe) r))]))

          (define (get-most loe)
            (foldr (λ (e1 e2) (if (> (entr-count e1) (entr-count e2)) e1 e2))
                   (first loe)
                   (rest loe)))]
    (--room r empty empty empty)))