;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P11_contains_key_tr) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Starting with the following data definition for a binary tree (not a binary search tree) 
; design a tail-recursive function called contains? that consumes a key and a binary tree 
; and produces #true if the tree contains the key.
; 


;; (NodeOf Integer String BT BT)
(define-struct node (k v l r))
;; interp. Binary tree node with key and value and left and right children.
(define BT (signature (mixed Node Boolean)))
;; Interp. Binary tree, either a node or #false for an empty tree.

(define BT1 #f)
(define BT2 (make-node 1 "a"
                       (make-node 6 "f"
                                  (make-node 4 "d" #f #f)
                                  #f)
                       (make-node 7 "g" #f #f)))

#;
(define (fn-for-bt bt)
  (cond [(false? bt) ...]
        [else (... (node-k bt)
                   (node-v bt)
                   (fn-for-bt (node-l bt))
                   (fn-for-bt (node-r bt)))]))


(: contains? (BT Integer -> Boolean))
;; Produce #true if the given binary tree contains a node with the given key.

(check-expect (contains? BT1 1) #f)
(check-expect (contains? BT2 1) #t)
(check-expect (contains? BT2 7) #t)
(check-expect (contains? BT2 4) #t)
(check-expect (contains? BT2 5) #f)

(define (contains? bt k)
  (local [(define (--bt bt todo)
            (cond [(false? bt) (--lobt todo)]
                  [(= k (node-k bt)) #t]
                  [else (--lobt (cons (node-l bt) (cons (node-r bt) todo)))]))

          (define (--lobt todo)
            (cond [(empty? todo) #f]
                  [else (--bt (first todo) (rest todo))]))]
    (--bt bt empty)))