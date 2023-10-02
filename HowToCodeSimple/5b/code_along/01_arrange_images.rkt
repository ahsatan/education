;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname 01_arrange_images) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; In this problem imagine you have a bunch of pictures that you would like to 
; store as data and present in different ways. We'll do a simple version of that 
; here, and set the stage for a more elaborate version later.
; 
; (A) Design a data definition to represent an arbitrary number of images.
; 
; (B) Design a function called arrange-images that consumes an arbitrary number
;     of images and lays them out left-to-right in increasing order of size.
;     


(require 2htdp/image)
(define Image (signature (predicate image?)))

;; (ListOf Image): one of
;; - empty
;; - (cons Image (ListOf Image))
;; interp. Arbitrary-length list of images.

(define LOI1 empty)
(define LOI2 (cons (circle 10 "outline" "red") empty))
(define LOI3 (cons (rectangle 20 32 "solid" "gold") LOI2))

#;
(define (fn-for-loi loi)
  (cond [(empty? loi) ...]
        [else (... (first loi)
                   (fn-for-loi (rest loi)))]))


(: arrange-images ((ListOf Image) -> Image))
;; Produce an image of all images in a list laid out L -> R in increasing size order (w x h)

(check-expect (arrange-images empty) empty-image)
(check-expect (arrange-images LOI2) (beside (circle 10 "outline" "red")
                                            empty-image))
(check-expect (arrange-images LOI3) (beside (circle 10 "outline" "red")
                                            (rectangle 20 32 "solid" "gold")
                                            empty-image))

(define (arrange-images loi)
  (layout-images (sort-images loi)))

(: layout-images ((ListOf Image) -> Image))
;; Produce an image of all images in a list laid out L -> R.

(check-expect (layout-images LOI3) (beside (rectangle 20 32 "solid" "gold")
                                            (circle 10 "outline" "red")
                                            empty-image))

(define (layout-images loi)
  (cond [(empty? loi) empty-image]
        [else (beside (first loi)
                      (layout-images (rest loi)))]))


(: sort-images ((ListOf Image) -> (ListOf Image)))
;; Produce a list of images, sorted in increasing size order (w x h).

(check-expect (sort-images LOI3) (cons (circle 10 "outline" "red")
                                       (cons (rectangle 20 32 "solid" "gold")
                                             empty)))

(define (sort-images loi)
  (cond [(empty? loi) empty]
        [else (sort-image (first loi)
                          (sort-images (rest loi)))]))


(: sort-image (Image (ListOf Image) -> (ListOf Image)))
;; Insert the given image into a list of images sorted in increasing size order (w x h).

(check-expect (sort-image (circle 12 "solid" "dark green") empty)
              (cons (circle 12 "solid" "dark green") empty))
(check-expect (sort-image (circle 12 "solid" "dark green") (cons (circle 10 "outline" "red") empty))
              (cons (circle 10 "outline" "red")
                    (cons (circle 12 "solid" "dark green") empty)))
(check-expect (sort-image (circle 10 "outline" "red") (cons (circle 12 "solid" "dark green") empty))
              (cons (circle 10 "outline" "red")
                    (cons (circle 12 "solid" "dark green") empty)))
(check-expect (sort-image (rectangle 20 32 "solid" "gold")
                          (cons (circle 10 "outline" "red")
                                (cons (circle 12 "solid" "dark green") empty)))
              (cons (circle 10 "outline" "red")
                    (cons (circle 12 "solid" "dark green")
                          (cons (rectangle 20 32 "solid" "gold") empty))))

(define (sort-image i loi)
  (cond [(empty? loi) (cons i empty)]
        [else (if (smaller? i (first loi))
                  (cons i loi)
                  (cons (first loi) (sort-image i (rest loi))))]))


(: smaller? (Image Image -> Boolean))
;; Produce #true if the first image is smaller than the second (w x h).

(check-expect (smaller? (circle 10 "outline" "red") (circle 12 "solid" "dark green")) #t)
(check-expect (smaller? (circle 12 "solid" "dark green") (circle 10 "outline" "red")) #f)

(define (smaller? a b)
  (< (* (image-width a) (image-height a)) (* (image-width b) (image-height b))))