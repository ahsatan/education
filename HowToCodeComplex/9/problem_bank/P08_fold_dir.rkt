;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P8_fold_dir) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; (DirOf String (ListOf Dir) (ListOf Image))
(define-struct dir (name sub-dirs images))
;; interp. A directory in the organizer with a name, a sub-dirs list, and an images list.

(define I1 (square 10 "solid" "red"))
(define I2 (square 10 "solid" "green"))
(define I3 (rectangle 13 14 "solid" "blue"))
(define D4 (make-dir "D4" empty (list I1 I2)))
(define D5 (make-dir "D5" empty (list I3)))
(define D6 (make-dir "D6" (list D4 D5) empty))

#;
(define (fn-for-dir d)
  (local [
          (define (--dir d)
            (... (dir-name d)
                 (--lod (dir-sub-dirs d))
                 (--loi (dir-images d))))

          (define (--lod lod)
            (cond [(empty? lod) ...]
                  [else (... (--dir (first lod))
                             (--lod (rest lod)))]))

          (define (--loi loi)
            (cond [(empty? loi) ...]
                  [else (... (first loi)
                             (--loi (rest loi)))]))]
    (--dir d)))


; 
; PROBLEM A
; 
; Design an abstract fold function for Dir called fold-dir. 
; 


;; (: fold-dir ((String Y Z -> X) (X Y -> Y) (Image Z -> Z) Y Z Dir -> X)
;; Abstract fold function for an image organizer.

(define (fold-dir fn-dir fn-lod fn-loi base-lod base-loi d)
  (local [
          (define (--dir d) ; X
            (fn-dir (dir-name d)
                    (--lod (dir-sub-dirs d))
                    (--loi (dir-images d))))

          (define (--lod lod) ; Y
            (cond [(empty? lod) base-lod]
                  [else (fn-lod (--dir (first lod))
                                (--lod (rest lod)))]))

          (define (--loi loi) ; Z
            (cond [(empty? loi) base-loi]
                  [else (fn-loi (first loi)
                                (--loi (rest loi)))]))]
    (--dir d)))


; 
; PROBLEM B
; 
; Design a function that consumes a Dir and produces the number of 
; images in the directory and its sub-directories.
; 


(: num-images (Dir -> Number))
;; Produce the total number of images in the image directory.

(check-expect (num-images D4) 2)
(check-expect (num-images D6) 3)

(define (num-images d)
  (local [(define (images-dir name images-lod images-loi) (+ images-lod images-loi))
          (define (images-loi Image images-loi) (+ 1 images-loi))]
  (fold-dir images-dir + images-loi 0 0 d)))


; 
; PROBLEM C
; 
; Design a function that consumes a Dir and a String. The function looks in
; dir and all its sub-directories for a directory with the given name. If it
; finds such a directory it should produce #true, otherwise #false.
; 


(: find-dir (Dir String -> Boolean))
;; Produce #true if a Dir with the given name exists, otherwise #false.

(check-expect (find-dir D5 "D3") #f)
(check-expect (find-dir D5 "D5") #t)
(check-expect (find-dir D6 "D4") #t)
(check-expect (find-dir D6 "D6") #t)
(check-expect (find-dir D6 "D3") #f)

(define (find-dir d s)
  (local [(define (dir-contains? name lod-result loi-result) (or (string=? s name) lod-result))
          (define (lod-contains? dir-result lod-result) (or dir-result lod-result))
          (define (nothing i loi-result) #f)]
    (fold-dir dir-contains? lod-contains? nothing #f #f d)))


; 
; PROBLEM D
; 
; Is fold-dir really the best way to code the function from part C? Why or 
; why not?
; 
; 1. No short circuiting.
; 
; 2. Unnecessary image sub-function.
; 
