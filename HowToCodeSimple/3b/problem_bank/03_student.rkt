;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 03_student) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM A
; 
; Design a data definition to help a teacher organize their next field trip. 
; On the trip, lunch must be provided for all students. For each student, track 
; their name, their grade (from 1 to 12), and whether or not they have allergies.
; 


;; (StudentOf (String Natural(1, 12), Boolean))
(define-struct student (name grade allergies?))
;; interp. Student information relevant to a field trip.

(define S1 (make-student "Allison" 3 #t))
(define S2 (make-student "Charles" 8 #f))

#;
(define (fn-for-student s)
  (... (student-name s)
       (student-grade s)
       (student-allergies? s)))

; 
; PROBLEM B
; 
; To plan for the field trip, if students are in grade 6 or below, the teacher 
; is responsible for keeping track of their allergies. If a student has allergies, 
; and is in a qualifying grade, their name should be added to a special list. 
; Design a function to produce true if a student name should be added to this list.
; 


(: special? (Student -> Boolean))
;; Produce #t if the student has allergies and is in grades 1 through 6.

(check-expect (special? (make-student "Sam" 5 #t)) #t)
(check-expect (special? (make-student "Amy" 6 #f)) #f)
(check-expect (special? (make-student "Cory" 7 #t)) #f)
(check-expect (special? (make-student "Maury" 10 #f)) #f)

(define (special? s)
  (and (>= 6 (student-grade s)) (student-allergies? s)))