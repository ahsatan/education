;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P3_height) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Design the function height, that consumes a BST and produces its height. Note that 
; the height of a BST is one plus the height of its highest child. You will want to 
; use the BSL max function in your solution. The height of a false tree is 0. The 
; height of (make-node 1 "a" false false) is 1.
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


(: height ((mixed Node Boolean) -> Natural))
;; Produce the height of the BST, 0 for an empty BST.

(check-expect (height BST0) 0)
(check-expect (height BST1) 1)
(check-expect (height BST10) 4)

(define (height bst)
  (cond [(false? bst) 0]
        [else (+  1 (max (height (node-left bst))
                         (height (node-right bst))))]))