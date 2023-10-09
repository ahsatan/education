;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname 04_fold_functions) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(define Image (signature (predicate image?)))

; 
; PROBLEM
; 
; Design an abstract fold function for (ListOf X). 
; 


;; (: foldr2 ((X Y -> Y) Y (ListOf X) -> Y))
;; Produce the result of applying fn to each element and culmination of the remainder of the list.

(check-expect (foldr2 + 0 (list 1 2 3 4)) 10)
(check-expect (foldr2 * 1 (list 1 2 3 4)) 24)
(check-expect (foldr2 string-append "" (list "a" "bc" "def")) "abcdef")

(define (foldr2 fn base lox)
  (cond [(empty? lox) base]
        [else (fn (first lox)
                  (foldr2 fn base (rest lox)))]))


; 
; PROBLEM
; 
; Complete the function definition for sum using foldr2. 
; 


(: sum ((ListOf Number) -> Number))
;; Produce the sum of all numbers in list.

(check-expect (sum empty) 0)
(check-expect (sum (list 2 3 4)) 9)

(define (sum lon)
  (foldr2 + 0 lon))


; 
; PROBLEM
; 
; Complete the function definition for juxtapose using foldr2. 
; 


(: juxtapose ((ListOf Image) -> Image))
;; Juxtapose all images beside each other.

(check-expect (juxtapose empty) (square 0 "solid" "white"))
(check-expect (juxtapose (list (triangle 6 "solid" "yellow")
                               (square 10 "solid" "blue")))
              (beside (triangle 6 "solid" "yellow")
                      (square 10 "solid" "blue")
                      (square 0 "solid" "white")))

(define (juxtapose loi)
  (foldr2 beside (square 0 "solid" "white") loi))


; 
; PROBLEM
; 
; Complete the function definition for copy-list using foldr2. 
; 


;; (: copy-list ((ListOf X) -> (ListOf X)))
;; Produce copy of list.

(check-expect (copy-list empty) empty)
(check-expect (copy-list (list 1 2 3)) (list 1 2 3))

(define (copy-list lox)
  (foldr2 cons empty lox))


; 
; PROBLEM
; 
; Design an abstract fold function for Element (and (listof Element)).
; 
; .
; 


;; (ElementOf String Integer (ListOf Element))
(define-struct element (name data subs))
;; interp. An element in the file system, with name, and EITHER data or subs.
;;         If data == 0, then subs is considered to be list of sub elements.
;;         If data != 0, then subs is ignored.

(define F1 (make-element "F1" 1 empty))
(define F2 (make-element "F2" 2 empty))
(define F3 (make-element "F3" 3 empty))
(define D4 (make-element "D4" 0 (list F1 F2)))
(define D5 (make-element "D5" 0 (list F3)))
(define D6 (make-element "D6" 0 (list D4 D5)))

#;
(define (fn-for-element e)
  (local [
          (define (fn-for-element e)
            (... (element-name e)
                 (element-data e)
                 (fn-for-loe (element-subs e))))

          (define (fn-for-loe loe)
            (cond [(empty? loe) ...]
                  [else (... (fn-for-element (first loe))
                             (fn-for-loe (rest loe)))]))]
    (fn-for-element e)))


;; (: foldr3 ((String Integer Y -> X) (X Y -> Y) Y Element -> X))
;; Produce the result of applying fn to each element and subdirectory elements.

(check-expect (local [(define (fn1 name data los) (cons name los))]
                (foldr3 fn1 append empty D6))
              (list "D6" "D4" "F1" "F2" "D5" "F3"))

(define (foldr3 fn1 fn2 base e)
  (local [
          (define (--element e)
            (fn1 (element-name e)
                 (element-data e)
                 (--loe (element-subs e))))

          (define (--loe loe)
            (cond [(empty? loe) base]
                  [else (fn2 (--element (first loe))
                             (--loe (rest loe)))]))]
    (--element e)))


; 
; PROBLEM
; 
; Complete the design of sum-data that consumes Element and produces
; the sum of all the data in the element and its subs.
; 


(: sum-data (Element -> Integer))
;; Produce the sum of all the data in element (and its subs).

(check-expect (sum-data F1) 1)
(check-expect (sum-data D5) 3)
(check-expect (sum-data D4) (+ 1 2))
(check-expect (sum-data D6) (+ 1 2 3))

(define (sum-data e)
  (local [(define (sum-data name data result) (+ data result))]
    (foldr3 sum-data + 0 e)))


; 
; PROBLEM
; 
; Complete the design of all-names that consumes Element and produces a list of the
; names of all the elements in the tree. 
; 


(: all-names (Element -> (ListOf String)))
;; Produce list of the names of all the elements in the tree.

(check-expect (all-names F1) (list "F1"))
(check-expect (all-names D5) (list "D5" "F3"))
(check-expect (all-names D4) (list "D4" "F1" "F2"))
(check-expect (all-names D6) (list "D6" "D4" "F1" "F2" "D5" "F3"))
               
(define (all-names e)
  (local [(define (cons-name name data result) (cons name result))]
  (foldr3 cons-name append empty e)))


; 
; PROBLEM
; 
; If the tree is very large, then fold-element is not a good way to implement the find 
; function from last week.  Why? If you aren't sure then discover the answer by implementing
; find using fold-element and then step the two versions with different arguments.
; 
; -> No short circuiting.
; 
