;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname P12_house_path_tr) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; Consider the following house diagram:
; 
; .
; 
; Starting from the porch, there are many paths through the house that you can
; follow without retracing your steps.  If we represent these paths as lists:
; (list 
;  (list "Porch")
;  (list "Porch" "Living Room")
;  (list "Porch" "Living Room" "Hall")
;  ...)
; 
; you can see that a lot of these paths start with the same sequence of rooms.
; We can represent these paths, and capture their shared initial parts, by using
; a tree:
; 
; .
; 


;; (PathOf String (ListOf Path))
(define-struct path (room nexts))
;; interp. An arbitrary-arity tree of paths with no loops.

(define P0 (make-path "A" empty))

(define PH 
  (make-path "Porch"
             (list 
              (make-path "Living Room"
                         (list
                          (make-path "Dining Room"
                                     (list
                                      (make-path"Kitchen"
                                                (list
                                                 (make-path "Hall"
                                                            (list
                                                             (make-path "Study" empty)
                                                             (make-path "Bedroom" empty)
                                                             (make-path "Bathroom" empty)))))))
                          (make-path "Hall"
                                     (list
                                      (make-path "Kitchen"
                                                 (list
                                                  (make-path "Dining Room" empty)))
                                      (make-path "Study" empty)
                                      (make-path "Bedroom" empty)
                                      (make-path "Bathroom" empty))))))))
   
#;
(define (fn-for-path p)
  (local [(define (--path p)
            (... (path-room p)
                 (--lop (path-nexts p))))
          
          (define (--lop lop)
            (cond [(empty? lop) ...]
                  [else (... (--path (first lop))
                             (--lop (rest lop)))]))]
    (fn-for-path p)))


(define NEVER "never")
(define Result (signature (enum #t #f NEVER)))
;; interp. Three possible answers to a question.

(define R0 #t)
(define R1 #f)
(define R2 NEVER)

#;
(define (fn-for-result r)
  (cond [(boolean? r) (... r)]
        [else (...)]))


(: and-result (Result Result -> Result))
;; Produce the logical combination of two results.

;  ╔════════════════╦═══════════════╦══════════════╗
;  ║                ║               ║              ║
;  ║            r0  ║    Boolean    ║    NEVER     ║
;  ║                ║               ║              ║
;  ║    r1          ║               ║              ║
;  ╠════════════════╬═══════════════╬══════════════╣
;  ║                ║               ║              ║
;  ║    Boolean     ║ (and r0 r1)   ║              ║
;  ║                ║               ║              ║
;  ╠════════════════╬═══════════════╣  r1          ║
;  ║                ║               ║              ║
;  ║     NEVER      ║  r0           ║              ║
;  ║                ║               ║              ║
;  ╚════════════════╩═══════════════╩══════════════╝


(check-expect (and-result #f #f) #f)
(check-expect (and-result #f #t) #f)
(check-expect (and-result #f NEVER) #f)
(check-expect (and-result #t #f) #f)
(check-expect (and-result #t #t) #t)
(check-expect (and-result #t NEVER) #t)
(check-expect (and-result NEVER #t) #t)
(check-expect (and-result NEVER #f) #f)
(check-expect (and-result NEVER NEVER) NEVER)

(define (and-result r0 r1)
  (cond [(and (boolean? r0) (boolean? r1)) (and r0 r1)]
        [(string? r0) r1]
        [else r0]))


; 
; PROBLEM 1  
; 
; Design a function called always-before that takes a path tree p and two room
; names b and c, and determines whether starting from p:
; 
; 1) you must pass through room b to get to room c (#true),
; 2) you can get to room c without passing through room b (#false), or
; 3) you just can't get to room c (produce NEVER).
; 
; Note that if b and c are the same room, you should produce #false since you don't
; need to pass through the room to get there.
; 
; Make it tail recursive.
; 


(: always-before (Path String String -> Result))
;; Produce #t if you must pass through room b to get to room c,
;;         #f if you can get to room c without passing b,
;;         NEVER if you can't get to room c.

(check-expect (always-before PH "Hall" "Observatory") NEVER)
(check-expect (always-before PH "Kitchen" "Kitchen") #f)
(check-expect (always-before PH "Bedroom" "Dining Room") #f)
(check-expect (always-before PH "Dining Room" "Bathroom") #f)
(check-expect (always-before PH "Living Room" "Kitchen") #t)
(check-expect (always-before PH "Hall" "Bathroom") #t)

(define (always-before p b c)
  (local [(define-struct np (path b?))

          (define (--path p todo b? res)
            (local [(define nb? (or b? (string=? b (path-room p))))
                    (define ntodo (append (map (λ (p) (make-np p nb?)) (path-nexts p)) todo))]
            (if (string=? c (path-room p))
                (--lop ntodo (and-result b? res))
                (--lop ntodo res))))
          
          (define (--lop todo res)
            (cond [(empty? todo) res]
                  [else (--path (np-path (first todo)) (rest todo) (np-b? (first todo)) res)]))]
    (--path p empty #f NEVER)))