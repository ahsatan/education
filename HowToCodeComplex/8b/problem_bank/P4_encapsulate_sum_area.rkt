;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P4_encapsulate_sum_area) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; In this exercise you will be need to remember the following DDs 
; for an image organizer.
; 


(require 2htdp/image)

;; (DirOf String (ListOf Dir) (ListOf Image))
(define-struct dir (name sub-dirs images))
;; interp. A directory in the organizer with a name, a sub-dirs list, and an images list.

;; (ListOf Dir): one of
;; - empty
;; - (cons Dir (ListOf Dir))
;; interp. Represents a list of sub-directories of a directory.

;; (ListOf Image): one of
;; - empty
;; - (cons Image (ListOf Image))
;; interp. Represents a list of sub-images of a directory.

(define I1 (square 10 "solid" "red"))
(define I2 (square 10 "solid" "green"))
(define I3 (rectangle 13 14 "solid" "blue"))
(define D4 (make-dir "D4" empty (list I1 I2)))
(define D5 (make-dir "D5" empty (list I3)))
(define D6 (make-dir "D6" (list D4 D5) empty))

#;
(define (fn-for-dir d)
  (... (dir-name d)
       (fn-for-lod (dir-sub-dirs d))
       (fn-for-loi (dir-images d))))

#;
(define (fn-for-lod lod)
  (cond [(empty? lod) ...]
        [else (... (fn-for-dir (first lod))
                   (fn-for-lod (rest lod)))]))

#;
(define (fn-for-loi loi)
  (cond [(empty? loi) ...]
        [else (... (first loi)
                   (fn-for-loi (rest loi)))]))

; 
; PROBLEM
; 
; Use local to encapsulate the functions so that sum-area--dir, sum-area--lod,
; sum-area--loi and area are private to a new function called sum-area.
; 


(: sum-area (Dir -> Natural))
;; Produce the sume of the area (width * height) of all the images in the image organizer.

(check-expect (sum-area D5) (* 13 14))
(check-expect (sum-area D4) 200)
(check-expect (sum-area D6) (+ (sum-area D5) (sum-area D4)))

(define (sum-area d)
  (local [
          (define (sum-area--dir d)
            (+ (sum-area--lod (dir-sub-dirs d))
               (sum-area--loi (dir-images d))))

          (define (sum-area--lod lod)
            (cond [(empty? lod) 0]
                  [else (+ (sum-area--dir (first lod))
                           (sum-area--lod (rest lod)))]))

          (define (sum-area--loi loi)
            (cond [(empty? loi) 0]
                  [else (+ (area (first loi))
                           (sum-area--loi (rest loi)))]))

          (define (area i)
            (* (image-width i) (image-height i)))]
    (sum-area--dir d)))
