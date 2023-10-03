;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P5_balance_factor) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; As discussed in lecture, for optimal lookup time we want a BST to be balanced. 
; The oldest approach to this is called AVL self-balancing trees and was invented in 1962. 
; The remainder of this problem set is based on AVL trees.
; 
; An individual node is balanced when the height of its left and right branches differ 
; by no more than 1. A tree is balanced when all its nodes are balanced.
; 
; a) Design the function balance-factor that consumes a node and produces its balance factor,
; which is defined as the height of its left child minus the height of its right child.
; 
; b) Use your function in part a) to design the function balanced?, which consumes a BST and 
; produces true if the tree is balanced at each node.
; 
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
(define BST42 (make-node 42 "ily" BST27 #f))
(define BST10 (make-node 10 "why" BST3 BST42))

#;
(define (fn-for-bst bst)
  (cond [(false? bst) ...]
        [else (... (node-key bst)
                   (node-val bst)
                   (fn-for-bst (node-left bst))
                   (fn-for-bst (node-right bst)))]))


(: balanced? ((mixed Node Boolean) -> Boolean))
;; Produce #true if all nodes in the BST have a balance factor <= 1.

(check-expect (balanced? BST0) #t)
(check-expect (balanced? BST1) #t)
(check-expect (balanced? BST27) #t)
(check-expect (balanced? BST3) #t)
(check-expect (balanced? BST42) #f)
(check-expect (balanced? BST10) #f)

(define (balanced? bst)
  (cond [(false? bst) #t]
        [else (and (<= (balance-factor bst) 1)
                   (balanced? (node-left bst))
                   (balanced? (node-right bst)))]))


(: balance-factor ((mixed Node Boolean) -> Integer))
;; Produce the balance factor of the given node.
;; Calculation: Absolute value of: height of left BST - height of right BST.

(check-expect (balance-factor BST0) 0)
(check-expect (balance-factor BST7) 0)
(check-expect (balance-factor BST3) 1)
(check-expect (balance-factor BST42) 2)
(check-expect (balance-factor BST10) 0)

(define (balance-factor bst)
  (cond [(false? bst) 0]
        [else (abs (- (height (node-left bst))
                      (height (node-right bst))))]))


(: height ((mixed Node Boolean) -> Natural))
;; Produce the height of the BST, 0 for an empty BST.

(check-expect (height BST0) 0)
(check-expect (height BST1) 1)
(check-expect (height BST10) 4)

(define (height bst)
  (cond [(false? bst) 0]
        [else (+  1 (max (height (node-left bst))
                         (height (node-right bst))))]))