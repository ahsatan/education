;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname 04_same_house_as_parent) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
; 
; PROBLEM
; 
; Design a representation of wizard family trees that includes, for each wizard,
; their name, the house they were placed in at Hogwarts and their children.
; 


(define GRYFF "Gryffindor")
(define SLYTH "Slytherin")
(define RAVEN "Ravenclaw")
(define HUFF "Hufflepuff")

(define House (signature (enum GRYFF SLYTH RAVEN HUFF)))

;; (WizOf String House (ListOf Wiz))
(define-struct wiz (name house children))

(define WA (make-wiz "A" SLYTH empty))
(define WB (make-wiz "B" GRYFF empty))
(define WC (make-wiz "C" RAVEN empty))
(define WD (make-wiz "D" HUFF empty))
(define WE (make-wiz "E" RAVEN empty))
(define WF (make-wiz "F" RAVEN (list WB)))
(define WG (make-wiz "G" SLYTH (list WA)))
(define WH (make-wiz "H" SLYTH (list WC WD)))
(define WI (make-wiz "I" HUFF empty))
(define WJ (make-wiz "J" RAVEN (list WE WF WG)))
(define WK (make-wiz "K" GRYFF (list WH WI WJ)))

#;
(define (fn-for-wiz w)
  (local [(define (--wiz w)
            (... (wiz-name w)
                 (wiz-house w)
                 (--low (wiz-children w))))

          (define (--low low)
            (cond [(empty? low) ...]
                  [else (... (--wiz (first low))
                             (--low (rest low)))]))]
    (--wiz w)))


; 
; PROBLEM
; 
; Design a function that consumes a wizard and produces the names of every 
; wizard in the tree that was placed in the same house as their immediate
; parent. 
; 


(: same-house (Wiz -> (ListOf String)))
;; Produce names of all Wiz in family tree in the same house as their direct parent.

(check-expect (same-house WA) empty)
(check-expect (same-house WH) empty)
(check-expect (same-house WG) (list "A"))
(check-expect (same-house WK) (list "E" "F" "A"))

(define (same-house w)
  (local [(define (--wiz w parent-house)
            (if (string=? parent-house (wiz-house w))
                (cons (wiz-name w) (--low (wiz-children w) (wiz-house w)))
                (--low (wiz-children w) (wiz-house w))))

          (define (--low low parent-house)
            (cond [(empty? low) empty]
                  [else (append (--wiz (first low) parent-house)
                                (--low (rest low) parent-house))]))]
    (--wiz w "")))


; 
; PROBLEM
; 
; Design a function that consumes a wizard and produces the number of wizards 
; in that tree (including the root). Your function should be tail recursive.
; 


(: num-wiz (Wiz -> Natural))
;; Produce the total number of wizards in the family tree.

(check-expect (num-wiz WA) 1)
(check-expect (num-wiz WH) 3)
(check-expect (num-wiz WK) 11)

#;
(define (num-wiz w)
  (local [(define (--wiz w count)
                 (--low (wiz-children w) (add1 count)))

          (define (--low low count)
            (cond [(empty? low) count]
                  [else (--low (rest low) (--wiz (first low) count))]))]
    (--wiz w 0)))

(define (num-wiz w)
  (local [(define (--wiz w todo count)
                 (--low (append todo (wiz-children w)) (add1 count)))  ; Breadth-first
               ; (--low (append (wiz-children w) todo) (add1 count)))  ; Depth-first
          
          (define (--low todo count)
            (cond [(empty? todo) count]
                  [else (--wiz (first todo) (rest todo) count)]))]
    (--wiz w empty 0)))


; 
; PROBLEM
; 
; Design a new function definition for same-house-as-parent that is tail 
; recursive. You will need a worklist accumulator.
; 


(: same-house-tr (Wiz -> (ListOf String)))
;; Produce names of all Wiz in family tree in the same house as their direct parent.
;; Uses tail recursion.

(check-expect (same-house-tr WA) empty)
(check-expect (same-house-tr WH) empty)
(check-expect (same-house-tr WG) (list "A"))
(check-expect (same-house-tr WK) (list "E" "F" "A"))

(define (same-house-tr w)
  (local [
          ;; (NwOf Wiz String)
          ;; interp. New wizard info holding the wizard and their parent's house.
          (define-struct nw (wiz ph))
          
          (define (--wiz w ph todo names)
            (local [(define (wiz->nw child) (make-nw child (wiz-house w)))
                    (define next-todo (append (map wiz->nw (wiz-children w)) todo))]
             (if (string=? ph (wiz-house w))
                 (--low next-todo (append names (list (wiz-name w))))
                 (--low next-todo names))))

          (define (--low todo names)
            (cond [(empty? todo) names]
                  [else (--wiz (nw-wiz (first todo)) (nw-ph (first todo)) (rest todo) names)]))]
    (--wiz w "" empty empty)))