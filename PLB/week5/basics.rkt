#lang racket

;; Needed for easy testing in separate file
(provide (all-defined-out))

;; Language Basics & Beyond

(define (sum xs)
  (cond [(empty? xs) 0]
        [else (+ (first xs) (sum (rest xs)))]))

(define (my-append xs ys)
  (cond [(empty? xs) ys]
        [else (cons (first xs) (my-append (rest xs) ys))]))

(define (my-map f xs)
  (cond [(empty? xs) empty]
        [else (cons (f (first xs)) (my-map f (rest xs)))]))

;; Sum nested list of numbers
(define (sum-nested xs)
  (cond [(empty? xs) 0]
        [(number? xs) xs]
        [(list? xs) (+ (sum (first xs)) (sum (rest xs)))]
        [else 0]))

;; Test for each cond case (and if) succeeds if result is anything except literally #f
(define (count-f xs)
  (cond [(empty? xs) 0]
        [(first xs) (count-f (rest xs))]
        [else (add1 (count-f (rest xs)))]))

(define (list-max xs)
  (cond [(empty? xs) (error "list-max has no elements")]
        [(empty? (first xs)) (first xs)]
        [else (let ([rest-max (list-max (rest xs))])
                (if (> (first xs) rest-max)
                    (first xs)
                    rest-max))]))

;; Let bindings all use env from BEFORE the let (here, the x referenced in y definition is outer x)
(define (silly-double x)
  (let ([x (+ x 3)]
        [y (+ x 2)])
    (+ x y -5)))

;; Let* bindings use all env prior to current binding (here, the x referenced in y is inner x)
;; - allows for shadowing
(define (extra-silly-double x)
  (let* ([x (+ x 3)]
         [y (+ x 2)])
    (+ x y -8)))

;; Letrec bindings use all env incl. letrec bindings after current binding (i.e. mutual recursion)
;; - expressions DO get evaluated in order so if f was called before w was defined it would error
(define (silly-triple x)
  (letrec ([y (+ x 2)]
           [f (λ (z) (+ z y w x))]
           [w (+ x 7)])
    (f -9)))

(define (silly-mod2 x)
  (letrec ([even? (λ (x) (if (zero? x) #t (odd? (sub1 x))))]
           [odd? (λ (x) (if (zero? x) #f (even? (sub1 x))))])
    (if (even? x) 0 1)))

#;
(define (bad-letrec x)
  (letrec ([y z]
           [z 13])
    (if x y z)))

;; BETTER SYNTAX for let/let*/letrec equivalent: local define
(define (silly-mod2-2 x)
  (define (even? x) (if (zero? x) #t (odd? (sub1 x))))
  (define (odd? x) (if (zero? x) #f (even? (sub1 x))))
  (if (even? x) 0 1))

;; Mutation: (set! x e) ("set bang")
(define b 3)
(define (f x) (* 1 (+ x b)))
(define c (+ b 4)) ; 7
(set! b 5)
(define z (f 4))   ; 9, closure w/ b ref set at f define but b val changed before this f call
(define w c)       ; 7, c determined to be 7 before b ref change and does not recalculate

;; Sequencing operator is useful with side effects: (begin e1 e2 ... en) => result is en

;; Pair vs list: list is nested pairs that ends in null/empty. Pair can simply end (cdr) on a value.
;; Pairs use car/cdr. Lists can use car/cdr or first/rest. dot (.) before final value = pair.
;; list? => #t for only (proper) lists including null/empty
;; pair? => #t for pairs (improper lists) and (proper) lists except null/empty (i.e. made with cons)
(cons 1 (cons #t "a"))              ; (1 #t . "a")
(cons 1 (cons #t (cons "a" empty))) ; (1 #t "a")

;; List Mutation: mcons = create, mcar mcdr = access, mpair? = check type, set-mcar! smcdr! = change
(define x (list 14))    ; (14)
(define y x)            ; (14)
(set! x (list 42))      ; (42) - where x points changed but the original cons still exists unchanged
y                       ; (14)
(define a (mcons 1 (mcons #t "hi")))
(set-mcar! (mcdr a) 14) ; a is (mcons 1 (14 "hi"))
(set-mcdr! a 47)        ; a is (mcons 1 47)

;; Eager argument evaluation for a function evaluates all args before running function
;; If only evaluates the branch the conditional indicates
;; BAD: bad-if forces eval of all args and infinite loop in bad-fact:
(define (bad-if pred? te fe)
  (if pred? te fe))

(define (bad-fact x)
  (bad-if (= x 0) 1 (* x (bad-fact (sub1 x)))))

;; THUNK: use zero-arg functions for function args to DELAY EVALUATION
(define (strange-if pred? te fe)
  (if pred? (te) (fe)))

(define (strange-fact x)
  (strange-if (= x 0)
              (λ () 1)
              (λ () (* x (strange-fact (sub1 x))))))

;; Thunk demo:
(define (slow-add x y)
  (define (slow-id y z)
    (cond [(zero? z) y]
          [else (slow-id y (sub1 z))]))
  (+ (slow-id x 50000000) y))

(define (slow-mult x y-thunk)
  (cond [(zero? x) 0]
        [(= 1 0) (y-thunk)]
        [else (+ (y-thunk) (slow-mult (sub1 x) y-thunk))]))

;; Very slow, instead of evaluating (slow-add 3 4) 1x it does 5x
;; using thunks can be bad if causes to evaluation slow expression multiple times
; (slow-mult 0 (λ () (slow-add 3 4))) ; fast, skips any calls to slow-add
; (slow-mult 5 (λ () (slow-add 3 4))) ; slow, evaluates slow-add 5 times
;; pre-evaluate to speed up if called:
; (slow-mult 5 (let ([x (slow-add 3 4)]) (λ () x))) ; faster, only calls slow-add 1x
; (slow-mult 0 (let ([x (slow-add 3 4)]) (λ () x))) ; slower, calls slow-add 1 time but never uses

;; Lazy evaluation: only evaluate an arg once it's used but then save it for future uses
;; See: Haskell, not Racket (but we can make our own w/ thunk and mcons)
;; Promise (lazy evaluation implementation): delay returns promise, force gets value of it
;; - ASSUME: evaluation has no side effects
(define (my-delay th)
  (mcons #f th)) ; #f = th is unevaluated

(define (my-force p)
  (cond [(mcar p) (mcdr p)]
        [else (begin (set-mcar! p #t)
                     (set-mcdr! p ((mcdr p)))
                     (mcdr p))]))

(slow-mult 0 (let ([p (my-delay (λ () (slow-add 3 4)))]) ; fast, never calls slow-add
               (λ () (my-force p)))) 
(slow-mult 5 (let ([p (my-delay (λ () (slow-add 3 4)))]) ; fast, only calls slow-add 1x
               (λ () (my-force p))))

;; STREAM using thunk that produces '(next-answer . next-thunk)
;; Careful about passing a Stream (thunk of pair) vs pair itself
(define ones (λ () (cons 1 ones))) ; Stream of: 1 1 1 1 1 ...

(define (nats)                     ; Stream of: 1 2 3 4 5 ...
  (define (f x) (cons x (λ () (f (add1 x)))))
    (λ () (f 1)))

(define (pows-of-2)                ; Stream of: 2 4 8 16 32 ...
  (define (f x) (cons x (λ () (f (* 2 x)))))
    (λ () (f 2)))

(define (stream-maker fn arg)      ; apply fn to the arg and the current value each thunk
  (define (f x) (cons x (λ () (f (fn x arg)))))
  (λ () (f arg)))
(define nats-2 (stream-maker + 1))
(define pows-of-2-2 (stream-maker * 2))

pows-of-2-2                 ; thunk
(pows-of-2-2)               ; (2 . next-thunk)
(car (pows-of-2-2))         ; 2
(car ((cdr (pows-of-2-2)))) ; 4
(cdr ((cdr (pows-of-2-2)))) ; next-thunk

(define (num-until stream pred?)
  (define (f stream ans)
    (define pr (stream))
    (cond [(pred? (car pr)) ans]
          [else (f (cdr pr) (add1 ans))]))
  (f stream 1))

(num-until pows-of-2-2 (λ (x) (> x 10000000000000000)))

;; MEMOIZATION
(define (fibonacci x)
  (define memo empty) ; pair-list (x . ans), outside f so it persists
  (define (f x)
    (define (fib x) (cond [(= x 1) 1]
                          [(= x 2) 1]
                          [else (+ (f (- x 1)) (f (- x 2)))]))
    (define ans-pr (assoc x memo)) ; assoc car-search pr-lst -> pr-search-res or #f
    (cond [ans-pr (cdr ans-pr)]
          [else (local [(define new-ans (fib x))]
                  (begin (set! memo (cons (cons x (force new-ans)) memo)) ; add new pr to memo
                         (force new-ans)))]))
  (f x))

;; MACROS: implement syntactic sugar (transform some syntax into other syntax)
(define-syntax my-if
  (syntax-rules (then else)     ; new keywords in parens
    [(my-if e1 then e2 else e3) ; new syntax
     (if e1 e2 e3)]))           ; what syntax converts to

(define-syntax comment-out
  (syntax-rules ()
    [(comment-out ignore result) result]))

(define-syntax my-delay-2 ; create promise (thunked exp) from EXPRESSION, do not pass thunk as arg
  (syntax-rules ()
    [(my-delay-2 e) (mcons #f (λ () e))])) ; (my-delay-2 (+ 3 2)) -> (mcons #f (λ () (+ 3 2)))

; No reason to macro my-force - does not improve syntax and less clean than function version

;; Hygienic Macros
;; Good style to stay l->r evaluation order (can change with local/let)
;; Behind the scenes: macros rename local variables so no conflicts
;;                    looks up variables used in macros where macro defined (lexical scope)
; Example is bad style but demonstrative:
(define (dbl x) (+ x x))   ; same as dbl-2
(define (dbl-2 x) (* 2 x)) ; same as dbl

; Not equivalent if have side effects!
(define-syntax mdbl (syntax-rules () [(mdbl x) (+ x x)]))
(define-syntax mdbl-2 (syntax-rules () [(mdbl-2 x) (* 2 x)]))

; Prevent x evaluating twice (unless you want it to evaluate multiple times for side effects)
(define-syntax mdbl3 (syntax-rules () [(mdbl3 x) (local [(define y x)] (+ y y))]))

; Re-used local var names do not conflict / get confused
; Lookup values where macro defined not where used
; Does NOT naively replace macro'd code exactly
(define-syntax mdbl4 (syntax-rules () [(mdbl4 x) (local [(define y 1)] (* 2 x y))]))
(local [(define y 7)] (mdbl4 y)) ; produces 14 despite y in both this local and in mdbl4 def

; Re-defined local functions do not get confused either
(define-syntax mdbl5 (syntax-rules () [(mdbl5 x) (* 2 x)]))
(local [(define * +)] (mdbl5 42))

; Force eval of expressions in order
(define-syntax for
  (syntax-rules (to do)
    [(for lo to hi do body)
     (local [(define l lo) ; lo evals only once
             (define h hi) ; hi evals only once
             (define (loop it)
               (or (> it h) (begin body (loop (add1 it)))))] ; body evals every loop
       (loop l))]))

(define (g x) (begin (print "A") x))
(define (h x) (begin (print "B") x))
(define (i x) (begin (print "C") x))
(for (g 7) to (h 11) do (i 9)) ; "A""B""C""C""C""C""C"#t

; Example with multiple syntax cases
(define-syntax let2
  (syntax-rules ()
    [(let2 () body) body]
    [(let2 (var v) body) (local [(define var v)] body)]
    [(let2 (var1 v1 var2 v2) body) (local  [(define var1 v1) (define var2 v2)] body)]))
(let2 (x 1 y 2) (+ x y))

(define-syntax let*2
  (syntax-rules ()
    [(let*2 () body) body]
    [(let*2 ([var0 v0] [var-rest v-rest] ...) body) ; ... allows any number of arg just prior
     (local [(define var0 v0)]
       (let*2 ([var-rest v-rest] ...) body))]))