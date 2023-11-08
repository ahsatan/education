#lang racket

;; Programming Languages Homework4 Simple Test

(require "hw4.rkt")
(require rackunit)

;; Helper functions
(define ones (lambda () (cons 1 ones)))
(define a 2)

(define tests
  (test-suite
   "Sample tests for Assignment 4"
   
   ; sequence test
   (check-equal? (sequence 0 5 1) (list 0 1 2 3 4 5) "Sequence test")
   (check-equal? (sequence 6 5 1) '() "Sequence test")
   (check-equal? (sequence 0 5 2) (list 0 2 4) "Sequence test")

   ; string-append-map test
   (check-equal? (string-append-map 
                  (list "dan" "dog" "curry" "dog2") 
                  ".jpg") '("dan.jpg" "dog.jpg" "curry.jpg" "dog2.jpg") "string-append-map test")
      (check-equal? (string-append-map '() ".jpg") '() "string-append-map test")
   
   ; list-nth-mod test
   (check-equal? (list-nth-mod (list 0 1 2 3 4) 2) 2 "list-nth-mod n < length test")
   (check-equal? (list-nth-mod (list 0 1 2 3 4) 5) 0 "list-nth-mod n = length test")
   (check-equal? (list-nth-mod (list 0 1 2 3 4) 8) 3 "list-nth-mod n > length test")
   (check-exn #rx"list-nth-mod: empty list" (λ () (list-nth-mod empty 2))
              "list-nth-mod empty test")
   (check-exn #rx"list-nth-mod: negative number" (λ () (list-nth-mod (list "a" "b") -1))
              "list-nth-mod negative test")
   
   ; stream-for-n-steps test
   (check-equal? (stream-for-n-steps ones 3) (list 1 1 1) "stream-for-n-steps test")
   
   ; funny-number-stream test
   (check-equal? (stream-for-n-steps funny-number-stream 16)
                 (list 1 2 3 4 -5 6 7 8 9 -10 11 12 13 14 -15 16)
                 "funny-number-stream test")
   
   ; dan-then-dog test
   (check-equal? (stream-for-n-steps dan-then-dog 3) (list "dan.jpg" "dog.jpg" "dan.jpg")
                 "dan-then-dog test")
   
   ; stream-add-zero test
   (check-equal? (stream-for-n-steps (stream-add-zero ones) 2) (list (cons 0 1) (cons 0 1))
                 "stream-add-zero test")
   (check-equal? (stream-for-n-steps (stream-add-zero dan-then-dog) 3)
                 (list (cons 0 "dan.jpg") (cons 0 "dog.jpg") (cons 0 "dan.jpg"))
                 "stream-add-dan-then-dog test")
   
   ; cycle-lists test
   (check-equal? (stream-for-n-steps (cycle-lists (list 1 2 3) (list "a" "b")) 5)
                 (list (cons 1 "a") (cons 2 "b") (cons 3 "a") (cons 1 "b") (cons 2 "a")) 
                 "cycle-lists test")
   
   ; vector-assoc test
   (check-equal? (vector-assoc 4 (vector (cons 2 1) (cons 3 1) (cons 4 1) (cons 5 1))) (cons 4 1)
                 "vector-assoc test")
   (check-equal? (vector-assoc 1 (vector (cons 2 1) (cons 3 1) (cons 4 1) (cons 5 1))) #f
                 "vector-assoc test")
   (check-equal? (vector-assoc 3 (vector (cons 2 1) (cons 3 2) (cons 3 1) (cons 5 1))) (cons 3 2)
                 "vector-assoc test")
   
   ; cached-assoc tests
   (check-equal? ((cached-assoc (list (cons 1 2) (cons 3 4)) 3) 3) (cons 3 4) "cached-assoc test")
   (check-equal? ((cached-assoc (list (cons 1 2) (cons 3 4) (cons 5 6)) 2) 4) #f
                 "cached-assoc test")
   
   ; while-less test
   (check-equal? (while-less 7 do (begin (set! a (+ a 1)) a)) #t "while-less test")
   (check-equal? a 7 "while-less a test")
   (check-equal? (while-less 7 do (begin (set! a (+ a 1)) a)) #t "while-less test")
   (check-equal? a 8 "while-less a test")
   ))

(require rackunit/text-ui)
;; runs the test
(run-tests tests)
