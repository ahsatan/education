;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname 04_bst_dd_lookup_render) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Design a data definition to represent binary search trees. As a reminder,
; here is one example BST:
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
(define (fn-for-bst n)
  (cond [(false? n) ...]
        [else (... (node-key n)
                   (node-val n)
                   (fn-for-bst (node-left n))
                   (fn-for-bst (node-right n)))]))


; 
; PROBLEM
; 
; Complete the design of the lookup-key function below.
; If the key is not found, the function should produce false.
; 


(: lookup-key ((mixed Node Boolean) Natural -> (mixed String Boolean)))
;; Produce the value associated with the given key in the BST or #false if the key does not exist.

(check-expect (lookup-key BST0 5) #f)
(check-expect (lookup-key BST10 5) #f)
(check-expect (lookup-key BST10 24) #f)
(check-expect (lookup-key BST10 10) "why")
(check-expect (lookup-key BST10 7) "ruf")
(check-expect (lookup-key BST10 14) "olp")

(define (lookup-key n k)
  (cond [(false? n) #f]
        [else (cond [(= k (node-key n)) (node-val n)]
                    [(< k (node-key n)) (lookup-key (node-left n) k)]
                    [else (lookup-key (node-right n) k)])]))


; 
; PROBLEM
; 
; Design a function that consumes a BST and produces a SIMPLE 
; rendering of that BST. Emphasis on SIMPLE: skip the lines.
; 


(require racket/format)
(require 2htdp/image)
(define Image (signature (predicate image?)))

(define SIZE 24)
(define COLOR "gold")
(define VSPACE (rectangle 1 10 "solid" "black"))
(define HSPACE (rectangle 10 1 "solid" "black"))
(define BLANK (rectangle 30 20 "solid" "black"))


(: render-bst ((mixed Node Boolean) -> Image))
;; Produce top-down rendering of the given BST.

(check-expect (render-bst #f) BLANK)
(check-expect (render-bst BST7) (above (text "7:ruf" SIZE COLOR)
                                       VSPACE
                                       (beside/align "top" BLANK HSPACE BLANK)))
(check-expect (render-bst BST4) (above (text "4:dcj" SIZE COLOR)
                                       VSPACE
                                       (beside/align "top" BLANK HSPACE (render-bst BST7))))
(check-expect (render-bst BST27) (above (text "27:wit" SIZE COLOR)
                                        VSPACE
                                        (beside/align "top" (render-bst BST14) HSPACE BLANK)))
(check-expect (render-bst BST3) (above (text "3:ilk" SIZE COLOR)
                                       VSPACE
                                       (beside/align "top"
                                                     (render-bst BST1)
                                                     HSPACE
                                                     (render-bst BST4))))
(check-expect (render-bst BST10) (above (text "10:why" SIZE COLOR)
                                        VSPACE
                                        (beside/align "top"
                                                      (render-bst BST3)
                                                      HSPACE
                                                      (render-bst BST42))))

(define (render-bst n)
  (cond [(false? n) BLANK]
        [else (above (text (string-append (~a (node-key n)) ":" (node-val n))
                           SIZE
                           COLOR)
                     VSPACE
                     (beside/align "top"
                                   (render-bst (node-left n))
                                   HSPACE
                                   (render-bst (node-right n))))]))