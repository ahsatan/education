;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P2_sum_keys) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Design a function that consumes a BST and produces the sum of all
; the keys in the BST.
; 
; .
; 


;; (BSTOf (mixed Node Boolean))
;; (NodeOf Natural String Node Node)
(define-struct node (key val left right))
;; interp. Node in a BST with key-value pair and references to left and right subtree nodes.
;;         Empty subtrees are represented with #false.
;; INVARIANT: Left node key < key < right node key. All keys are unique.

(define BST0 #f)
(define BST1 (make-node 1 "abc" #f #f))
(define BST7 (make-node 7 "ruf" #f #f))
(define BST4 (make-node 4 "dcj" #f BST7))
(define BST3 (make-node 3 "ilk" BST1 BST4))
(define BST14 (make-node 14 "olp" #f #f))
(define BST27 (make-node 27 "wit" BST14 #f))
(define BST50 (make-node 50 "dug" #f #f))
(define BST42 (make-node 42 "ily" BST27 BST50))
(define BST10 (make-node 10 "why" BST3 BST42))

#;
(define (fn-for-bst bst)
  (cond [(false? bst) ...]
        [else (... (node-key bst)
                   (node-val bst)
                   (fn-for-bst (node-left bst))
                   (fn-for-bst (node-right bst)))]))


(: sum-keys ((mixed Node Boolean) -> Natural))
;; Produce the sum of all the keys in the BST, 0 for an empty BST.

(check-expect (sum-keys BST0) 0)
(check-expect (sum-keys BST1) 1)
(check-expect (sum-keys BST10) (+ 10 3 1 4 7 42 27 14 50))

(define (sum-keys bst)
  (cond [(false? bst) 0]
        [else (+ (node-key bst)
                 (sum-keys (node-left bst))
                 (sum-keys (node-right bst)))]))