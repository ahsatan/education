;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname P3_university_names) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; (UniversityOf (String Number))
(define-struct university (name tuition))
;; interp. University name and international student tuition in USD.

(define U1 (make-university "Cornell" 40000))
(define U2 (make-university "Harvard" 52300))

#;
(define (fn-for-university u)
  (... (university-name u)
       (university-tuition u)))


;; (ListOf University): one of
;; - empty
;; - (cons University (ListOf University))
;; interp. List of international universities.

(define LOU1 empty)
(define LOU2 (cons U1 empty))
(define LOU3 (cons U2 (cons U1 empty)))

#;
(define (fn-for-lou lou)
  (cond [(empty? lou) ...]
        [else (... (fn-for-university (first lou))
                   (fn-for-lou (rest lou)))]))

; 
; PROBLEM
; 
; Design a function that consumes a ListOfSchool and produces a list of the 
; school names. Call it get-names.
; 


(: get-names ((ListOf University) -> (ListOf String)))
;; Produce a list of the university names.

(check-expect (get-names empty) empty)
(check-expect (get-names LOU2) (cons "Cornell" empty))
(check-expect (get-names LOU3) (cons "Harvard" (cons "Cornell" empty)))

(define (get-names lou)
  (cond [(empty? lou) empty]
        [else (cons (university-name (first lou))
                    (get-names (rest lou)))]))