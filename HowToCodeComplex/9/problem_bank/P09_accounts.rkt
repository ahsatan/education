;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P9_accounts) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define Accounts (signature (mixed Node Boolean)))
;; (NodeOf Natural String Integer Accounts Accounts)
(define-struct node (id name bal l r))
;; interp. Collection of bank accounts.
;;   #false represents an empty collection of accounts.
;;   - id: account identification number (and BST key)
;;   - name: account holder's name
;;   - bal: account balance in dollars CAD 
;;   - l and r: further collections of accounts
;; INVARIANT:
;;     id > ids in l
;;     id < ids in r
;;     All ids are unique.

(define A0 #f)
(define A1 (make-node 1 "Mr. Rogers"  22 #f #f))
(define A4 (make-node 4 "Mrs. Doubtfire"  -3
                      #f
                      (make-node 7 "Mr. Natural" 13 #f #f)))
(define A3 (make-node 3 "Miss Marple"  600 A1 A4))
(define A42 
  (make-node 42 "Mr. Mom" -79
             (make-node 27 "Mr. Selatcia" 40 
                        (make-node 14 "Mr. Impossible" -9 #f #f)
                        #f)
             (make-node 50 "Miss 604"  16 #f #f)))
(define A10 (make-node 10 "Dr. No" 84 A3 A42))

#;
(define (fn-for-act a)
  (cond [(false? a) ...]
        [else (... (node-id a)
                   (node-name a)
                   (node-bal a)
                   (fn-for-a (node-l a))
                   (fn-for-a (node-r a)))]))


; 
; PROBLEM 1
; 
; Design an abstract function to simplify remove-debtors and remove-profs below.
; 
; Then re-define the original remove-debtors and remove-profs functions 
; to use your abstract function.
; 


(: remove-debtors (Accounts -> Accounts))
;; Remove all accounts with a negative balance.

(check-expect (remove-debtors (make-node 1 "Mr. Rogers" 22 #f #f)) 
              (make-node 1 "Mr. Rogers" 22 #f #f))
(check-expect (remove-debtors (make-node 14 "Mr. Impossible" -9 #f #f))
              #f)
(check-expect (remove-debtors
               (make-node 27 "Mr. Selatcia" 40
                          (make-node 14 "Mr. Impossible" -9 #f #f)
                          #f))
              (make-node 27 "Mr. Selatcia" 40 #f #f))
(check-expect (remove-debtors 
               (make-node 4 "Mrs. Doubtfire" -3
                          #f 
                          (make-node 7 "Mr. Natural" 13 #f #f)))
              (make-node 7 "Mr. Natural" 13 #f #f))

#;
(define (remove-debtors a)
  (cond [(false? a) #f]
        [else
         (if (negative? (node-bal a))
             (join (remove-debtors (node-l a))
                   (remove-debtors (node-r a)))
             (make-node (node-id a)
                        (node-name a)
                        (node-bal a)
                        (remove-debtors (node-l a))
                        (remove-debtors (node-r a))))]))

(define (remove-debtors a)
  (local [(define (fn? id name bal) (negative? bal))]
    (remove-x fn? a)))


(: remove-profs (Accounts -> Accounts))
;; Remove all professors' accounts.

(check-expect (remove-profs (make-node 27 "Mr. Smith" 100000 #f #f)) 
              (make-node 27 "Mr. Smith" 100000 #f #f))
(check-expect (remove-profs (make-node 44 "Prof. Longhair" 2 #f #f)) #f)
(check-expect (remove-profs (make-node 67 "Mrs. Dash" 3000
                                       (make-node 9 "Prof. Booty" -60 #f #f)
                                       #f))
              (make-node 67 "Mrs. Dash" 3000 #f #f))
(check-expect (remove-profs 
               (make-node 97 "Prof. X" 7
                          #f 
                          (make-node 112 "Ms. Magazine" 467 #f #f)))
              (make-node 112 "Ms. Magazine" 467 #f #f))

#;
(define (remove-profs a)
  (cond [(false? a) #f]
        [else
         (if (has-prefix? "Prof." (node-name a))
             (join (remove-profs (node-l a))
                   (remove-profs (node-r a)))
             (make-node (node-id a)
                        (node-name a)
                        (node-bal a)
                        (remove-profs (node-l a))
                        (remove-profs (node-r a))))]))

(define (remove-profs a)
  (local [(define (fn? id name bal) (has-prefix? "Prof." name))]
    (remove-x fn? a)))


(: has-prefix? (String String -> Boolean))
;; Determine whether pre is a prefix of str.

(check-expect (has-prefix? "" "rock") #t)
(check-expect (has-prefix? "rock" "rockabilly") #t)
(check-expect (has-prefix? "blues" "rhythm and blues") #f)

(define (has-prefix? pre str)
  (string=? pre (substring str 0 (string-length pre))))


(: join (Accounts Accounts -> Accounts))
;; Combine two Accounts's into one.
;; ASSUMPTION: All ids in act1 are less than the ids in act2.

(check-expect (join A42 #f) A42)
(check-expect (join #f A42) A42)
(check-expect (join A1 A4) 
              (make-node 4 "Mrs. Doubtfire" -3
                         A1
                         (make-node 7 "Mr. Natural" 13 #f #f)))
(check-expect (join A3 A42) 
              (make-node 42 "Mr. Mom" -79
                         (make-node 27 "Mr. Selatcia" 40
                                    (make-node 14 "Mr. Impossible" -9
                                               A3
                                               #f)
                                    #f)
                         (make-node 50 "Miss 604" 16 #f #f)))

(define (join a1 a2)
  (cond [(false? a2) a1]
        [else
         (make-node (node-id a2) 
                    (node-name a2)
                    (node-bal a2)
                    (join a1 (node-l a2))
                    (node-r a2))]))


(: remove-x ((Natural String Integer -> Boolean) Accounts -> Accounts))
;; Abstract function to remove certain accounts based on criteria fn?.

(check-expect (local [(define (fn? id name bal) (negative? bal))]
                (remove-x fn? (make-node 1 "Mr. Rogers" 22 #f #f)))
              (make-node 1 "Mr. Rogers" 22 #f #f))
(check-expect (local [(define (fn? id name bal) (negative? bal))]
                (remove-x fn? (make-node 14 "Mr. Impossible" -9 #f #f)))
              #f)
(check-expect (local [(define (fn? id name bal) (negative? bal))]
                (remove-x fn? (make-node 27 "Mr. Selatcia" 40
                                         (make-node 14 "Mr. Impossible" -9 #f #f)
                                         #f)))
              (make-node 27 "Mr. Selatcia" 40 #f #f))
(check-expect (local [(define (fn? id name bal) (negative? bal))]
                (remove-x fn? (make-node 4 "Mrs. Doubtfire" -3
                                         #f 
                                         (make-node 7 "Mr. Natural" 13 #f #f))))
              (make-node 7 "Mr. Natural" 13 #f #f))
(check-expect (local [(define (fn? id name bal) (has-prefix? "Prof." name))]
                (remove-x fn? (make-node 67 "Mrs. Dash" 3000
                                         (make-node 9 "Prof. Booty" -60 #f #f)
                                         #f)))
              (make-node 67 "Mrs. Dash" 3000 #f #f))

(define (remove-x fn? a)
  (cond [(false? a) #f]
        [else
         (if (fn? (node-id a)
                  (node-name a)
                  (node-bal a))
             (join (remove-x fn? (node-l a))
                   (remove-x fn? (node-r a)))
             (make-node (node-id a)
                        (node-name a)
                        (node-bal a)
                        (remove-x fn? (node-l a))
                        (remove-x fn? (node-r a))))]))


; 
; PROBLEM 2
; 
; Using your new abstract function, design a function that removes from a given
; BST any account where the name of the account holder has an odd number of
; characters.  Call it remove-odd-characters.
; 


(: remove-odd-characters (Accounts -> Accounts))
;; Remove account holders whose names are an odd number of characters.

(check-expect (remove-odd-characters (make-node 67 "Mrs. Dashy" 3000
                                                (make-node 9 "Prof. Booty" -60 #f #f)
                                                #f))
              (make-node 67 "Mrs. Dashy" 3000 #f #f))

(define (remove-odd-characters a)
  (local [(define (fn? id name bal) (odd? (string-length name)))]
    (remove-x fn? a)))


; 
; PROBLEM 3
; 
; Design an abstract fold function for Accounts called fold-accounts. 
; 
; Use fold-accounts to design a function called charge-fee that decrements
; the balance of every account in a given collection by the monthly fee of 3 CAD.
; 


;; (: fold-act ((Natural String Integer Accounts Accounts -> X) X Accounts -> X))
;; Abstract fold function for a collection of bank Accounts.

(check-expect (local [(define (dec id name bal l r) (make-node id name (- bal 3) l r))]
                (fold-accounts dec #f (make-node 27 "Mr. Selatcia" 40
                                                 (make-node 14 "Mr. Impossible" -9 #f #f)
                                                 #f)))
              (make-node 27 "Mr. Selatcia" 37
                         (make-node 14 "Mr. Impossible" -12 #f #f)
                         #f))

(define (fold-accounts fn base a)
  (cond [(false? a) base]
        [else (fn (node-id a)
                  (node-name a)
                  (node-bal a)
                  (fold-accounts fn base (node-l a))
                  (fold-accounts fn base (node-r a)))]))


(: charge-fee (Number Accounts -> Accounts))
;; Reduce each account balance by 3 (monthly fee).

(check-expect (charge-fee 3 (make-node 27 "Mr. Selatcia" 40
                                       (make-node 14 "Mr. Impossible" -9 #f #f)
                                       #f))
              (make-node 27 "Mr. Selatcia" 37
                         (make-node 14 "Mr. Impossible" -12 #f #f)
                         #f))

(define (charge-fee fee a)
  (local [(define (dec id name bal l r) (make-node id name (- bal fee) l r))]
    (fold-accounts dec #f a)))


; 
; PROBLEM 4
; 
; Suppose you needed to design a function to look up an account based on its id.
; Would it be better to design the function using fold-act, or to design the
; function using the fn-for-acts template?  Briefly justify your answer.
; 
; A: fn-for-acts template because you can short circuit.
