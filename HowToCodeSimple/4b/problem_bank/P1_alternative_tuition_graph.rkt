;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P1_alternative_tuition_graph) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Consider the following alternative type comment for Eva's school tuition 
; information program. Note that this is just a single type, with no reference, 
; but it captures all the same information as the two types solution in the 
; videos.
; 
; (A) Confirm for yourself that this is a well-formed self-referential data 
;     definition.
; 
; (B) Complete the data definition making sure to define all the same examples as 
;     for ListOfSchool in the videos.
; 
; (C) Design the chart function that consumes School. Save yourself time by 
;     simply copying the tests over from the original version of chart.
; 
; (D) Compare the two versions of chart. Which do you prefer? Why?
; 


(require 2htdp/image)
(define Image (signature (predicate image?)))

(define WIDTH 25)
(define HEIGHT-SCALE 500)
(define COLOR "gold")
(define OUTLINE-COLOR "yellow")
(define TEXT-COLOR "black")
(define TEXT-SIZE 18)


;; (mixed Boolean (UniversityOf String Natural University)): one of
;; - false
;; - (make-university String Natural University)
;; interp. An arbitrary number of universities. Each has a name and tuition in USD.
(define-struct university (name tuition next))

(define U1 #f)
(define U2 (make-university "Cornell" 40000 U1))
(define U3 (make-university "Harvard" 52300 U2))

(define (fn-for-university u)
  (... (university-name u)
       (university-tuition u)
       (fn-for-university (university-next u))))


(: tuition-chart ((mixed Boolean University) -> Image))
;; Produce a bar chart of each university's international tuition.

(check-expect (tuition-chart #f) empty-image)
(check-expect (tuition-chart U2)
              (beside/align "bottom"
                            (tuition-bar U2)
                            empty-image))
(check-expect (tuition-chart U3)
              (beside/align "bottom"
                            (tuition-bar U3)
                            (tuition-bar U2)
                            empty-image))

(define (tuition-chart u)
  (cond [(false? u) empty-image]
        [else (beside/align "bottom"
                            (tuition-bar u)
                            (tuition-chart (university-next u)))]))


(: tuition-bar ((mixed Boolean University) -> Image))
;; Produce a single bar for a university's international tuition labeled with the university name.

(check-expect (tuition-bar U3)
              (overlay/align "center" "bottom"
                             (rotate 90 (text "Harvard" TEXT-SIZE TEXT-COLOR))
                             (rectangle WIDTH (/ 52300 HEIGHT-SCALE) "outline" OUTLINE-COLOR)
                             (rectangle WIDTH (/ 52300 HEIGHT-SCALE) "solid" COLOR)))

(define (tuition-bar u)
  (overlay/align "center" "bottom"
                 (rotate 90 (text (university-name u) TEXT-SIZE TEXT-COLOR))
                 (rectangle WIDTH (/ (university-tuition u) HEIGHT-SCALE) "outline" OUTLINE-COLOR)
                 (rectangle WIDTH (/ (university-tuition u) HEIGHT-SCALE) "solid" COLOR)))