;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname P3_hp_family_tree) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; 
; In this problem set you will represent information about descendant family 
; trees from Harry Potter and design functions that operate on those trees.
; 
; To make your task much easier we suggest two things:
;   - you only need a DESCENDANT family tree
;   - read through this entire problem set carefully to see what information 
;     the functions below are going to need. Design your data definitions to
;     only represent that information.
;   - you can find all the information you need by looking at the individual 
;     character pages like the one we point you to for Arthur Weasley.
; 


;; (WixOf String String String (ListOf Wix))
(define-struct wix (name patronus wand children))
;; interp. A Harry Potter wix with name, patronus animal, wand material, and any children.

;; (ListOf Wix): one of
;; - empty
;; - (cons Wix (ListOf Wix))
;; interp. A list of Harry Potter witches and wizards.

(define VICTOIRE (make-wix "Victoire" "" "" empty))
(define JAMES (make-wix "James" "" "" empty))
(define ALBUS (make-wix "Albus" "" "Cherry" empty))
(define LILY (make-wix "Lily" "" "" empty))
(define BILL (make-wix "William" "" "" (list VICTOIRE)))
(define CHARLIE (make-wix "Charles" "" "Ash" empty))
(define PERCY (make-wix "Percy" "" "" empty))
(define FRED (make-wix "Fred" "Magpie" "" empty))
(define GEORGE (make-wix "George" "Magpie" "" empty))
(define RON (make-wix "Ronald" "Jack Russel Terrier" "Ash" empty))
(define GINNY (make-wix "Ginevra" "Horse" "Yew" (list JAMES ALBUS LILY)))
(define ARTHUR (make-wix "Arthur" "Weasel" "" (list BILL CHARLIE PERCY FRED GEORGE RON GINNY)))

#;
(define (fn-for-wix w)
  (... (wix-name w)
       (wix-patronus w)
       (wix-wand w)
       (fn-for-low (wix-children w))))

#;
(define (fn-for-low low)
  (cond [(empty? low) ...]
        [else (... (fn-for-wix (first low))
                   (fn-for-low (rest low)))]))


; 
; PROBLEM 1
; 
; Design a function that produces a pair list (i.e. list of two-element lists)
; of every person in the tree and his or her patronus. For example, assuming 
; that HARRY is a tree representing Harry Potter and that he has no children
; (even though we know he does) the result would be: (list (list "Harry" "Stag")).
; 


(: patroni--wix (Wix -> (ListOf (ListOf String))))
(: patroni--low ((ListOf Wix) -> (ListOf (ListOf String))))
;; Produce list of pair lists of each family tree member's name and patronus.

(check-expect (patroni--low empty) empty)
(check-expect (patroni--wix VICTOIRE) (list (list "Victoire" "")))
(check-expect (patroni--wix ARTHUR) (list (list "Arthur" "Weasel")
                                          (list "William" "")
                                          (list "Victoire" "")
                                          (list "Charles" "")
                                          (list "Percy" "")
                                          (list "Fred" "Magpie")
                                          (list "George" "Magpie")
                                          (list "Ronald" "Jack Russel Terrier")
                                          (list "Ginevra" "Horse")
                                          (list "James" "")
                                          (list "Albus" "")
                                          (list "Lily" "")))

(define (patroni--wix w)
  (cons (list (wix-name w) (wix-patronus w))
        (patroni--low (wix-children w))))

(define (patroni--low low)
  (cond [(empty? low) empty]
        [else (append (patroni--wix (first low))
                      (patroni--low (rest low)))]))


; 
; PROBLEM 2
; 
; Design a function that produces the names of every person in a given tree 
; whose wands are made of a given material.
; 


(: wand=--wix (Wix String -> (ListOf String)))
(: wand=--low ((ListOf Wix) String -> (ListOf String)))
;; Produce all the wix with wands of the given wood.

(check-expect (wand=--low empty "Ash") empty)
(check-expect (wand=--wix ALBUS "Ash") empty)
(check-expect (wand=--wix ALBUS "Cherry") (list "Albus"))
(check-expect (wand=--wix ARTHUR "Ash") (list "Charles" "Ronald"))

(define (wand=--wix w wood)
  (if (string=? wood (wix-wand w))
      (cons (wix-name w) (wand=--low (wix-children w) wood))
      (wand=--low (wix-children w) wood)))

(define (wand=--low low wood)
  (cond [(empty? low) empty]
        [else (append (wand=--wix (first low) wood)
                      (wand=--low (rest low) wood))]))