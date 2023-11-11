#lang racket

;; Programming Languages Homework 5 Tests

(require "hw5.rkt")
(require rackunit)
(require rackunit/text-ui)

(define tests
  (test-suite
   "Tests for Assignment 5"
   
   ;; check racketlist to mupllist with normal and empty lists
   (check-equal? (racketlist->mupllist (list (int 3) (int 4)))
                 (apair (int 3) (apair (int 4) (aunit)))
                 "racketlist->mupllist test")
   (check-equal? (racketlist->mupllist empty) (aunit) "racketlist->mupllist empty test")
   
   ;; check mupllist to racketlist with normal and empty lists
   (check-equal? (mupllist->racketlist (apair (int 3) (apair (int 4) (aunit))))
                 (list (int 3) (int 4))
                 "racketlist->mupllist test")
   (check-equal? (mupllist->racketlist (aunit)) empty "mupllist->racketlist empty test")

   ;; tests if ifgreater returns (int 2)
   (check-equal? (eval-exp (ifgreater (int 3) (int 4) (int 3) (int 2))) (int 2) "ifgreater test")
   
   ;; mlet test
   (check-equal? (eval-exp (mlet "x" (int 1) (add (int 5) (var "x")))) (int 6) "mlet test")
   
   ;; call tests
   (check-equal? (eval-exp (call (closure '() (fun #f "x" (add (var "x") (int 7)))) (int 1)))
                 (int 8) "call test")
   (check-equal? (eval-exp-c (call (fun #f "x" (add (var "x") (int 7))) (int 1)))
                 (int 8) "call test")
   
   ;; snd test
   (check-equal? (eval-exp (snd (apair (int 1) (int 2)))) (int 2) "snd test")
   
   ;; isaunit test
   (check-equal? (eval-exp (isaunit (closure '() (fun #f "x" (aunit))))) (int 0) "isaunit test")
   
   ;; ifaunit tests
   (check-equal? (eval-exp (ifaunit (int 1) (int 2) (int 3))) (int 3) "ifaunit false eval test")
   (check-equal? (ifaunit (int 1) (int 2) (int 3))
                 (ifgreater (isaunit (int 1)) (int 0) (int 2) (int 3))
                 "ifaunit false macro test")
   (check-equal? (eval-exp (ifaunit (aunit) (int 2) (int 3))) (int 2) "ifaunit true eval test")
   (check-equal? (ifaunit (aunit) (int 2) (int 3))
                 (ifgreater (isaunit (aunit)) (int 0) (int 2) (int 3))
                 "ifaunit true macro test")
   
   ;; mlet* test
   (check-equal? (eval-exp (mlet* (list (cons "x" (int 10))) (var "x"))) (int 10) "mlet* test")
   
   ;; ifeq test
   (check-equal? (eval-exp (ifeq (int 1) (int 2) (int 3) (int 4))) (int 4) "ifeq test")
   
   ;; mupl-map tests
   (check-equal? (eval-exp (call (call mupl-map (fun #f "x" (add (var "x") (int 7))))
                                 (apair (int 1) (aunit)))) 
                 (apair (int 8) (aunit))
                 "mupl-map test")
   (check-equal? (eval-exp-c (mlet "y" (int 7)
                                   (call (call mupl-map (fun #f "x" (add (var "x") (var "y"))))
                                         (apair (int 1) (aunit))))) 
                 (apair (int 8) (aunit))
                 "mupl-map test")

   ;; check-free-vars test
   (check-equal? (compute-free-vars (mlet "y" (int 7) (fun "a" "x" (add (var "x") (var "y")))))
                 (mlet "y" (int 7) (fun-challenge "a" "x" (add (var "x") (var "y")) (set "y")))
                 "computer-free-vars test")
   
   ;; problems 1, 2, and 4 combined test
   (check-equal? (mupllist->racketlist
                  (eval-exp (call (call mupl-mapAddN (int 7))
                                  (racketlist->mupllist (list (int 3) (int 4) (int 9))))))
                 (list (int 10) (int 11) (int 16))
                 "combined test")
   ;; problems 1, 2, and 4 combined challenge test
   (check-equal? (mupllist->racketlist
                  (eval-exp-c (call (call mupl-mapAddN (int 7))
                                    (racketlist->mupllist (list (int 3) (int 4) (int 9))))))
                 (list (int 10) (int 11) (int 16))
                 "combined test")
   ))

(run-tests tests)