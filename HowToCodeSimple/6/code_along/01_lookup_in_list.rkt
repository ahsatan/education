;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 01_lookup_in_list) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; Consider the following data definition for representing an arbitrary number of user accounts.
; 


;; (AccountOf Natural String)
(define-struct account (num name))
;; interp. Account with account number and owner's first name.

;; (ListOf Account): one of
;; - empty
;; - (cons Account (ListOf Account))
;; interp. A list of accounts.

(define LOA1 empty)
(define LOA2 (list (make-account 1 "abc")
                   (make-account 4 "dcj")
                   (make-account 3 "ilk")
                   (make-account 7 "ruf")))

#;
(define (fn-for-accounts accs)
  (cond [(empty? accs) ...]
        [else (... (account-num  (first accs))
                   (account-name (first accs))
                   (fn-for-accounts (rest accs)))]))
                                   
                                   
; 
; PROBLEM
; 
; Complete the design of the lookup-name function below. If the account is not found,
; the function should produce #false.
; 


(: lookup ((ListOf Account) Natural -> (mixed String Boolean)))
;; Produce account name with given number if exists, otherwise produce #false.

(check-expect (lookup LOA1 1) #f)
(check-expect (lookup LOA2 2) #f)
(check-expect (lookup LOA2 3) "ilk")

(define (lookup loa n)
  (cond [(empty? loa) #f]
        [else (if (= n (account-num  (first loa)))
                  (account-name (first loa))
                  (lookup (rest loa) n))]))