;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname abstraction_quiz) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(define Image (signature (predicate image?)))

; 
; PROBLEM 1
;  
; Design an abstract function called arrange-all to simplify the 
; above-all and beside-all functions defined below. Rewrite above-all and
; beside-all using your abstract function.
; 


(: above-all ((ListOf Image) -> Image))
;; Combines a list of images into one image, each above the next.
(check-expect (above-all empty) empty-image)
(check-expect (above-all (list (rectangle 20 40 "solid" "red") (star 30 "solid" "yellow")))
              (above (rectangle 20 40 "solid" "red") (star 30 "solid" "yellow")))
(check-expect (above-all (list (circle 30 "outline" "black")
                               (circle 50 "outline" "black")
                               (circle 70 "outline" "black")))
              (above (circle 30 "outline" "black")
                     (circle 50 "outline" "black")
                     (circle 70 "outline" "black")))

#;
(define (above-all loi)
  (cond [(empty? loi) empty-image]
        [else (above (first loi)
                     (above-all (rest loi)))]))

(define (above-all loi)
  (arrange-all above empty-image loi))


(: beside-all ((ListOf Image) -> Image))
;; Combines a list of images into one image, each beside the next.
(check-expect (beside-all empty) (rectangle 0 0 "solid" "white"))
(check-expect (beside-all (list (rectangle 50 40 "solid" "blue") (triangle 30 "solid" "pink")))
              (beside (rectangle 50 40 "solid" "blue") (triangle 30 "solid" "pink")))
(check-expect (beside-all (list (circle 10 "outline" "red")
                                (circle 20 "outline" "blue")
                                (circle 10 "outline" "yellow")))
              (beside (circle 10 "outline" "red")
                      (circle 20 "outline" "blue")
                      (circle 10 "outline" "yellow")))

#;
(define (beside-all loi)
  (cond [(empty? loi) (rectangle 0 0 "solid" "white")]
        [else (beside (first loi)
                      (beside-all (rest loi)))]))

(define (beside-all loi)
  (arrange-all beside (rectangle 0 0 "solid" "white") loi))


(: arrange-all ((Image Image -> Image) Image (ListOf Image) -> Image))
;; Arrange the given images using the given fn.

(check-expect (arrange-all above empty-image empty) empty-image)
(check-expect (arrange-all above empty-image (list (rectangle 20 40 "solid" "red")
                                                   (star 30 "solid" "yellow")))
              (above (rectangle 20 40 "solid" "red") (star 30 "solid" "yellow")))
(check-expect (arrange-all above empty-image (list (circle 30 "outline" "black")
                                                   (circle 50 "outline" "black")
                                                   (circle 70 "outline" "black")))
              (above (circle 30 "outline" "black")
                     (circle 50 "outline" "black")
                     (circle 70 "outline" "black")))

(define (arrange-all fn base loi)
  (cond [(empty? loi) base]
        [else (fn (first loi)
                  (arrange-all fn base (rest loi)))]))


; 
; PROBLEM 2
;  
; Finish the design of the following functions, using built-in abstract functions. 
;  


(: lengths ((ListOf String) -> (ListOf Natural)))
;; Produce a list of the lengths of each string in los.

(check-expect (lengths empty) empty)
(check-expect (lengths (list "apple" "banana" "pear")) (list 5 6 4))

(define (lengths lst)
  (map string-length lst))


(: odd-only ((ListOf Natural) -> (ListOf Natural)))
;; Produce a list of only the odd elements of lon.

(check-expect (odd-only empty) empty)
(check-expect (odd-only (list 1 2 3 4 5)) (list 1 3 5))

(define (odd-only lon)
  (filter odd? lon))


(: all-odd? ((ListOf Natural) -> Boolean))
;; Produce #true if all elements of the list are odd.

(check-expect (all-odd? empty) true)
(check-expect (all-odd? (list 1 2 3 4 5)) false)
(check-expect (all-odd? (list 5 5 79 13)) true)

(define (all-odd? lon)
  (andmap odd? lon))


(: minus-n ((ListOf Natural) Natural -> (ListOf Integer)))
;; Subtract n from each element of the list.

(check-expect (minus-n empty 5) empty)
(check-expect (minus-n (list 4 5 6) 1) (list 3 4 5))
(check-expect (minus-n (list 10 5 7) 4) (list 6 1 3))

(define (minus-n lon n)
  (local [(define (subn a) (- a n))]
    (map subn lon)))


; 
; PROBLEM 3
;  
; Consider the data definition below for Region. Design an abstract fold function for region, 
; and then use it do design a function that produces a list of all the names of all the 
; regions in that region.
;  
; (all-regions CANADA) ->
; (list "Canada" "British Columbia" "Vancouver" "Victoria" "Alberta" "Calgary" "Edmonton")
; 


(define Type (signature (enum "Continent" "Country" "Province" "State" "City")))
;; interp. Categories of geographical regions.

;; (RegionOf (String Type (ListOf Region)))
(define-struct region (name type subregions))
;; interp. Geographical region.

(define VANCOUVER (make-region "Vancouver" "City" empty))
(define VICTORIA (make-region "Victoria" "City" empty))
(define BC (make-region "British Columbia" "Province" (list VANCOUVER VICTORIA)))
(define CALGARY (make-region "Calgary" "City" empty))
(define EDMONTON (make-region "Edmonton" "City" empty))
(define ALBERTA (make-region "Alberta" "Province" (list CALGARY EDMONTON)))
(define CANADA (make-region "Canada" "Country" (list BC ALBERTA)))

#;
(define (fn-for-region r)
  (local [(define (fn-for-region r)
            (... (region-name r)
                 (fn-for-type (region-type r))
                 (fn-for-lor (region-subregions r))))
          
          (define (fn-for-type t)
            (cond [(string=? t "Continent") (...)]
                  [(string=? t "Country") (...)]
                  [(string=? t "Province") (...)]
                  [(string=? t "State") (...)]
                  [(string=? t "City") (...)]))
          
          (define (fn-for-lor lor)
            (cond [(empty? lor) ...]
                  [else (... (fn-for-region (first lor))
                             (fn-for-lor (rest lor)))]))]
    (fn-for-region r)))


;; (: fold-region ((String Y Z -> X) (X Z -> Z) Z Y Y Y Y Y Region -> X))
;; Abstract fold function for a Region.

(define (fold-region fn-region fn-lor base-lor base-cont base-ctry base-prov base-sta base-city r)
  (local [(define (--region r)
            (fn-region (region-name r)
                       (--type (region-type r))
                       (--lor (region-subregions r))))
          
          (define (--type t)
            (cond [(string=? t "Continent") base-cont]
                  [(string=? t "Country") base-ctry]
                  [(string=? t "Province") base-prov]
                  [(string=? t "State") base-sta]
                  [(string=? t "City") base-city]))
          
          (define (--lor lor)
            (cond [(empty? lor) base-lor]
                  [else (fn-lor (--region (first lor))
                                (--lor (rest lor)))]))]
    (--region r)))


(: region-names (Region -> (ListOf String)))
;; Produce the list of all regions contained within the given region (including itself).

(check-expect (region-names VANCOUVER) (list "Vancouver"))
(check-expect (region-names BC) (list "British Columbia" "Vancouver" "Victoria"))
(check-expect (region-names CANADA) (list "Canada"
                                          "British Columbia"
                                          "Vancouver"
                                          "Victoria"
                                          "Alberta"
                                          "Calgary"
                                          "Edmonton"))

(define (region-names r)
  (local [(define (cons-name n ign lon) (cons n lon))]
    (fold-region cons-name append empty empty empty empty empty empty r)))