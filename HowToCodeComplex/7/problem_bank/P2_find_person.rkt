;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname P2_find_person) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; The following program implements an arbitrary-arity descendant family 
; tree in which each person can have any number of children.
; 


;; (PersonOf String Natural (ListOf Person))
(define-struct person (name age kids))
;; interp. A person with first name, age, and their children.

;; (ListOf Person): one of
;; - empty
;; - (cons Person (ListOf Person))
;; interp. A list of persons.

(define P1 (make-person "N1" 5 empty))
(define P2 (make-person "N2" 25 (list P1)))
(define P3 (make-person "N3" 15 empty))
(define P4 (make-person "N4" 45 (list P3 P2)))

#;
(define (fn-for-person p)
  (... (person-name p)
       (person-age p)
       (fn-for-lop (person-kids p))))

#;
(define (fn-for-lop lop)
  (cond [(empty? lop) ...]
        [else (... (fn-for-person (first lop))   
                   (fn-for-lop (rest lop)))]))


; 
; PROBLEM
; 
; Design a function that consumes a Person and a String. The function
; should search the entire tree looking for a person with the given 
; name. If found the function should produce the person's age. If not 
; found the function should produce #false.
; 


(: get-age--person (Person String -> (mixed Natural Boolean)))
(: get-age--lop ((ListOf Person) String -> (mixed Natural Boolean)))
;; Produce the age of the person with the given name or #false if they don't exist.

(check-expect (get-age--lop empty "N1") #f)
(check-expect (get-age--person P1 "N2") #f)
(check-expect (get-age--person P1 "N1") 5)
(check-expect (get-age--person P2 "N2") 25)
(check-expect (get-age--person P2 "N1") 5)
(check-expect (get-age--person P4 "N2") 25)

(define (get-age--person p name)
  (if (string=? name (person-name p))
      (person-age p)
      (get-age--lop (person-kids p) name)))

(define (get-age--lop lop name)
  (cond [(empty? lop) #f]
        [else (if (number? (get-age--person (first lop) name))
                  (get-age--person (first lop) name)
                  (get-age--lop (rest lop) name))]))