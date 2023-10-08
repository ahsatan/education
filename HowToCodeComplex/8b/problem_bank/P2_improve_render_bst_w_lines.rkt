;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P2_improve_render_bst_w_lines) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(define Image (signature (predicate image?)))

(define TEXT-SIZE  14)
(define TEXT-COLOR "BLACK")

(define KEY-VAL-SEPARATOR ":")

(define MTTREE (rectangle 20 1 "solid" "white"))


(define BST (signature (mixed Node Boolean)))
;; (NodeOf Natural String Node Node)
(define-struct node (key val l r))
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
                   (fn-for-bst (node-l n))
                   (fn-for-bst (node-r n)))]))


; 
; PROBLEM
; 
; Design a function that consumes a BST and produces a SIMPLE rendering of the BST
; including lines between nodes and their subnodes.
; 


(: render-bst (BST -> Image))
;; Produce SIMPLE rendering of BST.
;; ASSUME: BST is relatively well balanced.

(check-expect (render-bst false) MTTREE)
(check-expect (render-bst BST1)
              (above (render-key-val 1 "abc") 
                     (lines (image-width (render-bst false))
                            (image-width (render-bst false)))
                     (beside (render-bst false)
                             (render-bst false))))

(define (render-bst bst)
  (cond [(false? bst) MTTREE]
        [else
         (local [(define lbst (render-bst (node-l bst)))
                 (define rbst (render-bst (node-r bst)))]
           (above (render-key-val (node-key bst) (node-val bst))
                  (lines (image-width lbst) (image-width rbst))
                  (beside lbst rbst)))]))

(: render-key-val (Integer String -> Image))
;; Render key-value pair to form the body of a node.

(check-expect (render-key-val 99 "foo") 
              (text (string-append "99" KEY-VAL-SEPARATOR "foo") TEXT-SIZE TEXT-COLOR))

(define (render-key-val k v)
  (text (string-append (number->string k)
                       KEY-VAL-SEPARATOR
                       v)
        TEXT-SIZE
        TEXT-COLOR))


(: lines (Natural Natural -> Image))
;; Produce lines to l/r subtrees based on width of those subtrees.

(check-expect (lines 60 130)
              (add-line (add-line (rectangle (+ 60 130) (/ 190 4) "solid" "white")
                                  (/ (+ 60 130) 2) 0
                                  (/ 60 2)         (/ 190 4)
                                  "black")
                        (/ (+ 60 130) 2) 0
                        (+ 60 (/ 130 2)) (/ 190 4)
                        "black"))

(define (lines lw rw)
  (add-line (add-line (rectangle (+ lw rw) (/ (+ lw rw) 4) "solid" "white")
                      (/ (+ lw rw) 2)  0
                      (/ lw 2)         (/ (+ lw rw) 4)
                      "black")
            (/ (+ lw rw) 2)  0
            (+ lw (/ rw 2))  (/ (+ lw rw) 4)
            "black"))


; 
; PROBLEM
; 
; Improve the performance of render-bst.
; 


;; These trees are NOT legal binary SEARCH trees.
;; But for tests on rendering speed that won't matter.

(define BSTA (make-node 100 "A" BST10 BST10))
(define BSTB (make-node 101 "B" BSTA BSTA))
(define BSTC (make-node 102 "C" BSTB BSTB))
(define BSTD (make-node 103 "D" BSTC BSTC))
(define BSTE (make-node 104 "E" BSTD BSTD))
(define BSTF (make-node 104 "E" BSTE BSTE))

(time (rest (list (render-bst BSTA))))
(time (rest (list (render-bst BSTB))))
(time (rest (list (render-bst BSTC))))
(time (rest (list (render-bst BSTD))))
(time (rest (list (render-bst BSTE))))