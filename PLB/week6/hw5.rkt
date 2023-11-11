;; Programming Languages, Homework 5

#lang racket
(provide (all-defined-out))

;; Structure definitions for MUPL programs
(struct var       (string)              #:transparent) ;; a variable, e.g., (var "foo")
(struct int       (num)                 #:transparent) ;; a constant number, e.g., (int 17)
(struct add       (e1 e2)               #:transparent) ;; add two expressions
(struct ifgreater (e1 e2 e3 e4)         #:transparent) ;; if e1 > e2 then e3 else e4
(struct fun       (nameopt formal body) #:transparent) ;; a recursive(?) 1-argument function
(struct call      (funexp actual)       #:transparent) ;; function call
(struct mlet      (var e body)          #:transparent) ;; a local binding (let var = e in body) 
(struct apair     (e1 e2)               #:transparent) ;; make a new pair
(struct fst       (e)                   #:transparent) ;; get first part of a pair
(struct snd       (e)                   #:transparent) ;; get second part of a pair
(struct aunit     ()                    #:transparent) ;; unit value -- good for ending a list
(struct isaunit   (e)                   #:transparent) ;; evaluate to 1 if e is unit else 0

;; Closure is evaluation of struct fun: not in "source" programs but IS a MUPL value
(struct closure   (env fun)             #:transparent) 

;; Problem 1
(define (racketlist->mupllist xs)
  (cond [(empty? xs) (aunit)]
        [else (apair (first xs) (racketlist->mupllist (rest xs)))]))

(define (mupllist->racketlist xs)
  (cond [(aunit? xs) empty]
        [else (cons (apair-e1 xs) (mupllist->racketlist (apair-e2 xs)))]))

;; Problem 2
(define (envlookup env str)
  (cond [(null? env) (error "unbound variable during evaluation" str)]
        [(equal? (car (car env)) str) (cdr (car env))]
        [else (envlookup (cdr env) str)]))

(define (eval-under-env e env)
  (cond [(int? e) e]
        [(aunit? e) e]
        [(var? e) (envlookup env (var-string e))]
        [(isaunit? e) (if (aunit? (eval-under-env (isaunit-e e) env))
                          (int 1)
                          (int 0))]
        [(mlet? e) (eval-under-env (mlet-body e)
                                   (cons (cons (mlet-var e)
                                               (eval-under-env (mlet-e e) env))
                                         env))]
        [(apair? e) (apair (eval-under-env (apair-e1 e) env)
                           (eval-under-env (apair-e2 e) env))]
        [(fst? e) (local [(define pr (eval-under-env (fst-e e) env))]
                    (if (apair? pr)
                        (apair-e1 pr)
                        (error "MUPL fst applied to non-pair")))]
        [(snd? e) (local [(define pr (eval-under-env (snd-e e) env))]
                    (if (apair? pr)
                        (apair-e2 pr)
                        (error "MUPL snd applied to non-pair")))]
        [(add? e) (local [(define v1 (eval-under-env (add-e1 e) env))
                          (define v2 (eval-under-env (add-e2 e) env))]
                    (if (and (int? v1)
                             (int? v2))
                        (int (+ (int-num v1)
                                (int-num v2)))
                        (error "MUPL addition applied to non-number")))]
        [(ifgreater? e) (local [(define v1 (eval-under-env (ifgreater-e1 e) env))
                                (define v2 (eval-under-env (ifgreater-e2 e) env))]
                          (if (and (int? v1)
                                   (int? v2))
                              (if (> (int-num v1) (int-num v2))
                                  (eval-under-env (ifgreater-e3 e) env)
                                  (eval-under-env (ifgreater-e4 e) env))
                              (error "MUPL ifgreater comparison applied to non-number")))]
        [(fun? e) (closure env e)]
        [(closure? e) e]
        [(call? e) (local [(define cl (eval-under-env (call-funexp e) env))]
                     (if (closure? cl)
                         (local [(define arg (eval-under-env (call-actual e) env))
                                 (define f (closure-fun cl))
                                 (define cl-env (cons (cons (fun-formal f) arg)
                                                      (if (fun-nameopt f)
                                                          (cons (cons (fun-nameopt f) cl)
                                                                (closure-env cl))
                                                          (closure-env cl))))]
                           (eval-under-env (fun-body f) cl-env))
                         (error "MUPL call applied to non-closure")))]
        [else (error (format "bad MUPL expression: ~v" e))]))

(define (eval-exp e)
  (eval-under-env e null))
        
;; Problem 3
(define (ifaunit e1 e2 e3)
  (ifgreater (isaunit e1) (int 0) e2 e3))

(define (mlet* xs e)
  (cond [(empty? xs) e]
        [else (mlet (car (first xs))
                    (cdr (first xs))
                    (mlet* (rest xs) e))]))

(define (ifeq e1 e2 e3 e4)
  (mlet "_x" e1
        (mlet "_y" e2
              (ifgreater (var "_x") (var "_y")
                         e4
                         (ifgreater (var "_y") (var "_x")
                                    e4
                                    e3)))))

;; Problem 4
(define mupl-map
  (fun #f "f"
       (fun "loop" "xs"
            (ifaunit (var "xs")
                     (aunit)
                     (apair (call (var "f") (fst (var "xs")))
                            (call (var "loop") (snd (var "xs"))))))))

(define mupl-mapAddN 
  (mlet "map" mupl-map
        (fun #f "i" (call (var "map")
                          (fun #f "v" (add (var "v") (var "i")))))))

;; Challenge Problem
(struct fun-challenge (nameopt formal body freevars) #:transparent) ;; recursive(?) 1-arg function

;; Bubble up added vars, remove defined ones, convert fun
(define (compute-free-vars e)
  (struct ne (e fvs))
  (define (f e)
    (cond [(int? e) (ne e (set))]
          [(aunit? e) (ne e (set))]
          [(var? e) (ne e (set (var-string e)))]
          [(isaunit? e) (local [(define ne1 (f (isaunit-e e)))]
                          (ne (isaunit (ne-e ne1))
                              (ne-fvs ne1)))]
          [(mlet? e) (local [(define ne1 (f (mlet-e e)))
                             (define ne2 (f (mlet-body e)))]
                       (ne (mlet (mlet-var e)
                                 (ne-e ne1)
                                 (ne-e ne2))
                           (set-remove (set-union (ne-fvs ne1)
                                                  (ne-fvs ne2))
                                       (mlet-var e))))]
          [(apair? e) (local [(define ne1 (f (apair-e1 e)))
                              (define ne2 (f (apair-e2 e)))]
                        (ne (apair (ne-e ne1)
                                   (ne-e ne2))
                            (set-union (ne-fvs ne1)
                                       (ne-fvs ne2))))]
          [(fst? e) (local [(define ne1 (f (fst-e e)))]
                      (ne (fst (ne-e ne1))
                          (ne-fvs ne1)))]
          [(snd? e) (local [(define ne1 (f (snd-e e)))]
                      (ne (snd (ne-e ne1))
                          (ne-fvs ne1)))]
          [(add? e) (local [(define ne1 (f (add-e1 e)))
                            (define ne2 (f (add-e2 e)))]
                      (ne (add (ne-e ne1)
                               (ne-e ne2))
                          (set-union (ne-fvs ne1)
                                     (ne-fvs ne2))))]
          [(ifgreater? e) (local [(define ne1 (f (ifgreater-e1 e)))
                                  (define ne2 (f (ifgreater-e2 e)))
                                  (define ne3 (f (ifgreater-e3 e)))
                                  (define ne4 (f (ifgreater-e4 e)))]
                            (ne (ifgreater (ne-e ne1)
                                           (ne-e ne2)
                                           (ne-e ne3)
                                           (ne-e ne4))
                                (set-union (ne-fvs ne1)
                                           (ne-fvs ne2)
                                           (ne-fvs ne3)
                                           (ne-fvs ne4))))]
          [(fun? e) (local [(define ne1 (f (fun-body e)))
                            (define nfvs (set-remove (if (fun-nameopt e)
                                                         (set-remove (ne-fvs ne1) (fun-nameopt e))
                                                         (ne-fvs ne1))
                                                     (fun-formal e)))]
                      (ne (fun-challenge (fun-nameopt e)
                                         (fun-formal e)
                                         (ne-e ne1)
                                         nfvs)
                          nfvs))]
          [(call? e) (local [(define ne1 (f (call-funexp e)))
                             (define ne2 (f (call-actual e)))]
                       (ne (call (ne-e ne1)
                                 (ne-e ne2))
                           (set-union (ne-fvs ne1)
                                      (ne-fvs ne2))))]))
  (ne-e (f e)))

(define (eval-under-env-c e env)
  (cond [(int? e) e]
        [(aunit? e) e]
        [(var? e) (envlookup env (var-string e))]
        [(isaunit? e) (if (aunit? (eval-under-env-c (isaunit-e e) env)) (int 1) (int 0))]
        [(mlet? e) (eval-under-env-c (mlet-body e)
                                     (cons (cons (mlet-var e)
                                                 (eval-under-env-c (mlet-e e) env))
                                           env))]
        [(apair? e) (apair (eval-under-env-c (apair-e1 e) env) (eval-under-env-c (apair-e2 e) env))]
        [(fst? e) (local [(define pr (eval-under-env-c (fst-e e) env))]
                    (if (apair? pr)
                        (apair-e1 pr)
                        (error "MUPL fst applied to non-pair")))]
        [(snd? e) (local [(define pr (eval-under-env-c (snd-e e) env))]
                    (if (apair? pr)
                        (apair-e2 pr)
                        (error "MUPL snd applied to non-pair")))]
        [(add? e) (local [(define v1 (eval-under-env-c (add-e1 e) env))
                          (define v2 (eval-under-env-c (add-e2 e) env))]
                    (if (and (int? v1)
                             (int? v2))
                        (int (+ (int-num v1)
                                (int-num v2)))
                        (error "MUPL addition applied to non-number")))]
        [(ifgreater? e) (local [(define v1 (eval-under-env-c (ifgreater-e1 e) env))
                                (define v2 (eval-under-env-c (ifgreater-e2 e) env))]
                          (if (and (int? v1)
                                   (int? v2))
                              (if (> (int-num v1) (int-num v2))
                                  (eval-under-env-c (ifgreater-e3 e) env)
                                  (eval-under-env-c (ifgreater-e4 e) env))
                              (error "MUPL ifgreater comparison applied to non-number")))]
        [(fun-challenge? e) (closure (filter (λ (x) (set-member? (fun-challenge-freevars e)
                                                                 (car x)))
                                             env)
                                     e)]
        [(closure? e) e]
        [(call? e) (local [(define cl (eval-under-env-c (call-funexp e) env))]
                     (if (closure? cl)
                         (local [(define arg (eval-under-env-c (call-actual e) env))
                                 (define f (closure-fun cl))
                                 (define cl-env (cons (cons (fun-challenge-formal f) arg)
                                                      (if (fun-challenge-nameopt f)
                                                          (cons (cons (fun-challenge-nameopt f) cl)
                                                                (closure-env cl))
                                                          (closure-env cl))))]
                           (eval-under-env-c (fun-challenge-body f) cl-env))
                         (error "MUPL call applied to non-closure")))]
        [else (error (format "bad MUPL expression: ~v" e))]))

(define (eval-exp-c e)
  (eval-under-env-c (compute-free-vars e) null))