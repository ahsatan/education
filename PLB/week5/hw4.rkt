#lang racket

(provide (all-defined-out))

;; Problem 1
;; ASSUME: stride > 0
(define (sequence low high stride)
  (if (> low high)
      empty
      (cons low (sequence (+ low stride) high stride))))

;; Problem 2
;; REQUIRE: map, string-append
(define (string-append-map xs suffix)
  (map (λ (s) (string-append s suffix)) xs))

;; Problem 3
;; RECOMMEND: length, remainder, car, list-tail
(define (list-nth-mod xs n)
  (cond [(negative? n) (error "list-nth-mod: negative number")]
        [(empty? xs) (error "list-nth-mod: empty list")]
        [else (list-ref xs (modulo n (length xs)))]))

;; Problem 4
;; ASSUME: n >= 0
(define (stream-for-n-steps s n)
  (if (zero? n)
      empty
      (local [(define pr (s))]
        (cons (car pr) (stream-for-n-steps (cdr pr) (sub1 n))))))

;; Problem 5
;; NOTE: Functions definition with 0 parameters is syntactic sugar for thunk.
(define (funny-number-stream)
  (define (f x)
    (cons (if (zero? (modulo x 5)) (- x) x)
          (λ () (f (add1 x)))))
  (f 1))

;; Problem 6
(define (dan-then-dog)
  (cons "dan.jpg" (λ () (cons "dog.jpg" dan-then-dog))))

;; Problem 7
(define (stream-add-zero s)
  (λ () (define pr (s))
    (cons (cons 0 (car pr))
          (stream-add-zero (cdr pr)))))

;; Problem 8
;; RECOMMEND: list-nth-mod
(define (cycle-lists xs ys)
  (define (f n)
    (cons (cons (list-nth-mod xs n) (list-nth-mod ys n))
          (λ () (f (add1 n)))))
  (λ () (f 0)))
    
;; Problem 9
;; REQUIRE: vector-length, vector-ref, equal?
(define (vector-assoc v vec)
  (define (f i)
    (if (>= i (vector-length vec))
        #f
        (local [(define e (vector-ref vec i))]
          (if (and (pair? e) (equal? v (car e)))
              e
              (f (add1 i))))))
  (f 0))

;; Problem 10
;; ASSUME: n > 0
;; REQUIRE: vector cache
(define (cached-assoc xs n)
  (define cache (make-vector n #f))
  (define pos 0)
  (define (lookup v)
    (define ans (assoc v xs))
    (and ans
         (begin (vector-set! cache pos ans)
                (set! pos (modulo (add1 pos) n))
                ans)))
  (define (f v)
    (or (vector-assoc v cache)
        (lookup v)))
  f)
    
;; Challenge Problem
;; REQUIRE: eval e1 once, eval e2 >= once
(define-syntax while-less
  (syntax-rules (do)
    [(while-less e1 do e2)
     (local [(define v1 e1)
             (define (f)
               (or (>= e2 v1)
                   (f)))]
       (f))]))