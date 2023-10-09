;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname 01_parameterization) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define (area r)
  (* pi (sqr r)))

(area 4) ;; (* pi (sqr 4))
(area 6) ;; (* pi (sqr 6))



(: contains? (String (ListOf String) -> Boolean))
;; Produce #true if los contains the given string.

(check-expect (contains? "UBC" empty) #f)
(check-expect (contains? "UBC" (cons "McGill" empty)) #f)
(check-expect (contains? "UBC" (cons "UBC" empty)) #t)
(check-expect (contains? "UBC" (cons "McGill" (cons "UBC" empty))) #t)
(check-expect (contains? "UBC" (cons "UBC" (cons "McGill" empty))) #t)
(check-expect (contains? "Toronto" (cons "UBC" (cons "McGill" empty))) #f)

(define (contains? s los)
  (cond [(empty? los) #f]
        [else (or (string=? s (first los))
                  (contains? s (rest los)))]))


(: contains-ubc? ((ListOf String) -> Boolean))
;; Produce #true if los includes "UBC".

(check-expect (contains-ubc? empty) #f)
(check-expect (contains-ubc? (cons "McGill" empty)) #f)
(check-expect (contains-ubc? (cons "UBC" empty)) #t)
(check-expect (contains-ubc? (cons "McGill" (cons "UBC" empty))) #t)

(define (contains-ubc? los)
  (contains? "UBC" los))


(: contains-mcgill? ((ListOf String) -> Boolean))
;; Produce #true if los includes "McGill".

(check-expect (contains-mcgill? empty) #f)
(check-expect (contains-mcgill? (cons "UBC" empty)) #f)
(check-expect (contains-mcgill? (cons "McGill" empty)) #t)
(check-expect (contains-mcgill? (cons "UBC" (cons "McGill" empty))) #t)

(define (contains-mcgill? los)
  (contains? "McGill" los))



;; (: map2 ((X -> Y) (ListOf X) -> (ListOf Y)))
;; Produce list applying fn to each given list element.

(check-expect (map2 sqr empty) empty)
(check-expect (map2 sqr (list 3 4)) (list 9 16))
(check-expect (map2 sqrt (list 9 16)) (list 3 4))
(check-expect (map2 abs (list 2 -3 4)) (list 2 3 4))
(check-expect (map2 string-length (list "a" "bc" "def")) (list 1 2 3))

(define (map2 fn lox)
  (cond [(empty? lox) empty]
        [else (cons (fn (first lox))
                    (map2 fn (rest lox)))]))


(: squares ((ListOf Number) -> (ListOf Number)))
;; Produce list of sqr of every number in lon.

(check-expect (squares empty) empty)
(check-expect (squares (list 3 4)) (list 9 16))

(define (squares lon)
  (map2 sqr lon))


(: square-roots ((ListOf Number) -> (ListOf Number)))
;; Produce list of sqrt of every number in lon.

(check-expect (square-roots empty) empty)
(check-expect (square-roots (list 9 16)) (list 3 4))

(define (square-roots lon)
  (map2 sqrt lon))



;; (: filter2 ((X -> Boolean) (ListOf X) -> (ListOf X)))
;; Produce sub-list of the given list where each element meets the condition fn?.

(check-expect (filter2 positive? empty) empty)
(check-expect (filter2 positive? (list 1 -2 3 -4)) (list 1 3))
(check-expect (filter2 negative? (list 1 -2 3 -4)) (list -2 -4))

(define (filter2 fn? lox)
  (cond [(empty? lox) empty]
        [else (if (fn? (first lox))
                  (cons (first lox)
                        (filter2 fn? (rest lox)))
                  (filter2 fn? (rest lox)))]))


(: positive-only ((ListOf Number) -> (ListOf Number)))
;; Produce list with only positive? elements of lon.

(check-expect (positive-only empty) empty)
(check-expect (positive-only (list 1 -2 3 -4)) (list 1 3))

(define (positive-only lon)
  (filter2 positive? lon))


(: negative-only ((ListOf Number) -> (ListOf Number)))
;; Produce list with only negative? elements of lon.

(check-expect (negative-only empty) empty)
(check-expect (negative-only (list 1 -2 3 -4)) (list -2 -4))

(define (negative-only lon)
  (filter2 negative? lon))
