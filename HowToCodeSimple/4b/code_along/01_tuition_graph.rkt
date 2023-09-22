;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname 01_tuition_graph) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Eva is trying to decide where to go to university. One important factor for her is 
; tuition costs. Eva is a visual thinker, and has taken Systematic Program Design, 
; so she decides to design a program that will help her visualize the costs at 
; different schools. She decides to start simply, knowing she can revise her design
; later.
; 
; The information she has so far is the names of some schools as well as their 
; international student tuition costs. She would like to be able to represent that
; information in bar charts like this one:
; 
; 
;         .
;         
; (A) Design data definitions to represent the information Eva has.
; (B) Design a function that consumes information about schools and their
;     tuition and produces a bar chart.
; (C) Design a function that consumes information about schools and produces
;     the school with the lowest international student tuition.
; 


(require 2htdp/image)
(define Image (signature (predicate image?)))

(define WIDTH 25)
(define HEIGHT-SCALE 500)
(define COLOR "gold")
(define OUTLINE-COLOR "yellow")
(define TEXT-COLOR "black")
(define TEXT-SIZE 18)


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


(: tuition-chart ((ListOf University) -> Image))
;; Produce a bar chart of each university's international tuition.

(check-expect (tuition-chart empty) empty-image)
(check-expect (tuition-chart (cons U1 empty))
              (beside/align "bottom"
                            (tuition-bar U1)
                            empty-image))
(check-expect (tuition-chart (cons U2 (cons U1 empty)))
              (beside/align "bottom"
                            (tuition-bar U2)
                            (tuition-bar U1)
                            empty-image))

(define (tuition-chart lou)
  (cond [(empty? lou) empty-image]
        [else (beside/align "bottom"
                            (tuition-bar (first lou))
                            (tuition-chart (rest lou)))]))


(: tuition-bar (University -> Image))
;; Produce a single bar for a university's international tuition labeled with the university name.

(check-expect (tuition-bar (make-university "Cornell" 40000))
              (overlay/align "center" "bottom"
                             (rotate 90 (text "Cornell" TEXT-SIZE TEXT-COLOR))
                             (rectangle WIDTH (/ 40000 HEIGHT-SCALE) "outline" OUTLINE-COLOR)
                             (rectangle WIDTH (/ 40000 HEIGHT-SCALE) "solid" COLOR)))

(define (tuition-bar u)
  (overlay/align "center" "bottom"
                 (rotate 90 (text (university-name u) TEXT-SIZE TEXT-COLOR))
                 (rectangle WIDTH (/ (university-tuition u) HEIGHT-SCALE) "outline" OUTLINE-COLOR)
                 (rectangle WIDTH (/ (university-tuition u) HEIGHT-SCALE) "solid" COLOR)))


(: cheapest ((ListOf University) -> University))
;; Produce the university with the cheapest tuition in the list.  Assume list of at least length 1.

(check-expect (cheapest (cons (make-university "Stanford" 46300) empty))
              (make-university "Stanford" 46300))
(check-expect (cheapest (cons (make-university "California Polytechnic SLO" 18400)
                              (cons (make-university "Stanford" 46300)
                                    empty)))
              (make-university "California Polytechnic SLO" 18400))
(check-expect (cheapest (cons (make-university "Stanford" 46300)
                              (cons (make-university "California Polytechnic SLO" 18400)
                                    empty)))
              (make-university "California Polytechnic SLO" 18400))

(define (cheapest lou)
  (cond [(empty? (rest lou)) (first lou)]
        [else (if (< (university-tuition (first lou))
                     (university-tuition (cheapest (rest lou))))
                  (first lou)
                  (cheapest (rest lou)))]))