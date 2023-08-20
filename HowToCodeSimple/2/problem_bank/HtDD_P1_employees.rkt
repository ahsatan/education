;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname HtDD_P1_employees) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM A
; 
; You work in the Human Resources department at a ski lodge. 
; Because the lodge is busier at certain times of year, 
; the number of employees fluctuates. 
; There are always more than 10, but the maximum is 50.
; 
; Design a data definition to represent the number of ski lodge employees. 
; Call it Employees.
; 


(: valid_num_employees? (Natural -> Boolean))
(define (valid_num_employees? n)
  (<= 11 n 50))

(define Employees (signature (predicate valid_num_employees?)))
;; interp. Number of employees at a ski lodge.

(define E1 11)
(define E2 24)
(define E3 50)

#;
(define (fn-for-employees e)
  (... e))

; 
; PROBLEM B
; 
; Now design a function that will calculate the total payroll for the quarter.
; Each employee is paid $1,500 per quarter. Call it calculate-payroll.
; 


(: calculate-payroll (Employees -> Natural))
;; Produce the total payroll for the quarter at a rate of $1,500 per employee.

(check-expect (calculate-payroll 11) 16500)
(check-expect (calculate-payroll 50) 75000)

#;
(define (calculate-payroll e) 0)

#;
(define (calculate-payroll e)
  (... e))

(define (calculate-payroll e)
  (* 1500 e))