;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname 02_file_system_with_local) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(define Image (signature (predicate image?)))


;; (ElementOf String Integer (ListOf Element))
(define-struct element (name data subs))
;; interp. An element in the file system, with name, and EITHER data or subs.
;;         If data == 0, then subs is considered to be list of sub elements.
;;         If data != 0, then subs is ignored.

;; (ListOf Element): one of
;; - empty
;; - (cons Element (ListOf Element))
;; interp. A list of file system Elements.

; .


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



; 
; PROBLEM
; 
; Design a function that consumes Element and produces the sum of all the file data in 
; the tree.
; 


(: sum-data (Element -> Integer))
;; Produce the sum of all the files in the file tree starting at the given element.

(check-expect (sum-data F1) 1)
(check-expect (sum-data D4) 3)
(check-expect (sum-data D6) 6)

(define (sum-data e)
  (local [(define (sum-data--element e)
            (+ (element-data e)
               (sum-data--loe (element-subs e))))

          (define (sum-data--loe loe)
            (cond [(empty? loe) 0]
                  [else (+ (sum-data--element (first loe))
                           (sum-data--loe (rest loe)))]))]
    (sum-data--element e)))


; 
; PROBLEM
; 
; Design a function that consumes Element and produces a list of the names of all the elements in 
; the tree. 
; 


(: element-names (Element -> (ListOf String)))
;; Produce a list of names of all the elements in the file tree starting at the given element.

(check-expect (element-names F1) (list "F1"))
(check-expect (element-names D4) (list "D4" "F1" "F2"))
(check-expect (element-names D6) (list "D6" "D4" "F1" "F2" "D5" "F3"))

(define (element-names e)
  (local [(define (element-names--element e)
            (cons (element-name e)
                  (element-names--loe (element-subs e))))

          (define (element-names--loe loe)
            (cond [(empty? loe) empty]
                  [else (append (element-names--element (first loe))
                                (element-names--loe (rest loe)))]))]
    (element-names--element e)))


; 
; PROBLEM
; 
; Design a function that consumes String and Element and looks for a data element with the given 
; name. If it finds that element it produces the data, otherwise it produces false.
; 


(: find-name (String Element -> (mixed Integer Boolean)))
;; Produce the data for the element that matches the given name or #false if it doesn't exist.

(check-expect (find-name "F1" F2) #f)
(check-expect (find-name "F1" D5) #f)
(check-expect (find-name "F1" F1) 1)
(check-expect (find-name "F3" D5) 3)
(check-expect (find-name "F2" D6) 2)
(check-expect (find-name "D4" D4) 0)
(check-expect (find-name "D4" D6) 0)

(define (find-name name e)
  (local [(define (find-name--element name e)
            (if (string=? name (element-name e))
                (element-data e)
                (find-name--loe name (element-subs e))))

          (define (find-name--loe name loe)
            (cond [(empty? loe) #f]
                  [else (local [(define found (find-name--element name (first loe)))]
                          (if (number? found)
                              found
                              (find-name--loe name (rest loe))))]))]
    (find-name--element name e)))