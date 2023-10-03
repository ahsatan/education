;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P4_insert) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Design a function that consumes an Integer, String and BST, and adds a node
; that has the given key and value to the tree. The node should be inserted in 
; the proper place in the tree. The function can assume there is not already 
; an entry for that number in the tree. The function should produce the new BST.
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


(: insert ((mixed Node Boolean) Natural String -> (mixed Node Boolean)))
;; Produce an updated BST with the given node added.
;; ASSUME: Unique key.

(check-expect (insert BST0 1 "abc") BST1)
(check-expect (insert BST1 7 "ruf") (make-node 1 "abc" #f BST7))
(check-expect (insert BST7 1 "abc") (make-node 7 "ruf" BST1 #f))
(check-expect (insert BST3 2 "qro")
              (make-node 3 "ilk" (make-node 1 "abc" #f (make-node 2 "qro" #f #f)) BST4))

(define (insert bst key val)
  (cond [(false? bst) (make-node key val #f #f)]
        [(< key (node-key bst)) (make-node (node-key bst)
                                           (node-val bst)
                                           (insert (node-left bst) key val)
                                           (node-right bst))]
        [else (make-node (node-key bst)
                         (node-val bst)
                         (node-left bst)
                         (insert (node-right bst) key val))]))