#lang racket

;; struct automatically creates:
;; - constructor: (foo e1 e2 e3)
;; - pred: (foo? e) -> #t if e was made with above constructor
;; - field access: (foo-bar e) (foo-baz e) (foo-quux e) -> will error if not called on a foo
;; #:transparent allows REPL to display struct contents
;; #:mutable adds additional functions to set! fields, e.g. (set-foo-bar! e)
(struct foo (bar baz quux) #:transparent)

;; Very simple arithmetic language defined in Racket syntax
(struct const (i) #:transparent)        ;; i must be a number
(struct negate (e) #:transparent)
(struct add (e1 e2) #:transparent)
(struct multiply (e1 e2) #:transparent)

;; Simple interpreter
(define (eval-exp e)
  (define (e->i  fname e)
    (define exp (eval-exp e))
    (cond [(const? exp) (const-i exp)]
          [else (error (string-append fname " applied to non-number"))]))
  (define (e->b fname e)
    (define exp (eval-exp e))
    (cond [(bool? exp) (bool-b e)]
          [else (error (string-append fname " applied to non-boolean"))]))
  (cond [(const? e) e]
        [(negate? e) (const (- (e->i "negate" (negate-e e))))]
        [(add? e) (const (+ (e->i "add" (add-e1 e))
                            (e->i "add" (add-e2 e))))]
        [(multiply? e) (const (* (e->i "multiply" (multiply-e1 e))
                                 (e->i "multiply" (multiply-e2 e))))]
        [(bool? e) e]
        [(eq-num? e) (bool (= (e->i "eq-num?" (eq-num-e1 e))
                              (e->i "eq-num?" (eq-num-e2 e))))]
        [(if-then-else? e) (if (e->b "if-then-else" (if-then-else-e1 e))
                               (eval-exp (if-then-else-e2 e))
                               (eval-exp (if-then-else-e3 e)))]
        [else (error "eval-exp expected an exp")]))

;; Programming Language Implementation
;; - start w/ a string: "concrete syntax"
;; - parse: syntax errors like missing parens or keyword in wrong position, etc. generates....
;; - abstract syntax tree: can check for errors and type checking
;; - implementation: interpreter (i.e. run program) or compiler (i.e. produce translated code)

;; Version in Racket: have user create AST using structs
; (struct call ...)
; (struct function ...)
; (struct var ...)

;; "(fn x => x + x) -4"
#;
(call (function (list "x")     ;; arg list
                (add (var "x") ;; fn body
                     (var "x")))
      (negate (const 4)))      ;; arg to call function with

;; For our purposes, we can assume a given AST is valid and crash/fail oddly if not
;; On the other hand, we MUST type check constructors are used with appropriate values
;; Our language will always return a value not an incompletely interpreted language expression
;; - e.g. proper error message if try to add a const and bool
;; - valid types: numbers, booleans, strings, pairs of values, closures

;; Extend arithmetic language above:
(struct bool (b) #:transparent)                 ;; b must be #t or #f
(struct eq-num (e1 e2) #:transparent)
(struct if-then-else (e1 e2 e3) #:transparent)

;; Valid AST and interpretation
(define t1 (multiply (negate (add (const 2)
                                  (const 2)))
                     (const 7)))
;; Valid AST but bad incorrect type returned from if-then-else to multiply
(define t2 (multiply (negate (add (const 2)
                                  (const 2)))
                     (if-then-else (bool #f)
                                   (const 7)
                                   (bool #t))))
;; Invalid AST - const should not be created with #t
(define t3 (multiply (negate (add (const #t)
                                  (const 2)))
                     (const 7)))

;; Variables & Environment
;; (ListOf (PairOf String Value))  (string -> name, value -> const or bool type here)
;; Pass env down - add on as declarations added for sub evals
#;
(define (eval-exp e)
  (define (eval-under-env e env) ; on hw, make top level for grading
    (cond ...))
  (eval-under-env e empty))

;; Defining Functions (not a value itself): Closures (are a value)
;; env is current env when function evaluated
;; fun is an expression w/ args and body, not a value, eval function returns a closure
(struct closure (env fun) #:transparent)

;; Calling Functions:
;; e1 is evaluated to a closure in the current environment
;; e2 (argument) is evaluated to a value in the current environment
;; eval closure function BODY with closure env extended with
;; - (arg-name-from-function arg-value)
;; - (fname closure) for recursion
; (call e1 e2)

;; Smarter: only save "free variables" () to closure env
;; - "free variable": used but not bound in function body (not shadowed w/ arg or defined inside)
;; Normally a "pre-pass" of interpreter/compiler: determine and save with each function
;; Also use a set (or balanced tree or hashmap) instead of list
(define x 1)
(define y 2)
(define z 3)
(λ () (+ x y z))                             ; {x, y, z}
(λ (x) (+ y z))                              ; {y, z}
(λ (x) (if x y z))                           ; {y, z}
(λ (x) (define y 0) (+ x y z))               ; {z}
(λ (x y z) (+ x y z))                        ; {}
(λ (x) (+ y (local [(define y z)] (+ y y)))) ; {y, z}

;; Racket functions can act as macros (take syntax and return other syntax) for our language:
(define (andalso e1 e2)
  (if-then-else e1 e2 (bool #f)))
; REPL for below: (in-then-else (bool #t) (eq-num (const 3) (const 4)) (bool #f))
(andalso (bool #t) (eq-num (const 3) (const 4)))

(define (double e)
  (multiply e (const 2)))

(define (list-product es)
  (cond [(empty? es) (const 1)]
        [else (multiply (first es) (list-product (rest es)))]))

(define t4 (andalso (eq-num (double (const 4))
                            (list-product (list (const 2) (const 2) (const 1) (const 2))))
                    (bool #t)))