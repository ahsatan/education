;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname 02_using_built_ins) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(define Image (signature (predicate image?)))

(define I1 (rectangle 10 20 "solid" "red"))
(define I2 (rectangle 30 20 "solid" "yellow"))
(define I3 (rectangle 40 50 "solid" "green"))
(define I4 (rectangle 60 50 "solid" "blue"))
(define I5 (rectangle 90 90 "solid" "orange"))

(define LOI1 (list I1 I2 I3 I4 I5))


(: wide? (Image -> Boolean))
(: tall? (Image -> Boolean))
(: square? (Image -> Boolean))
;; Produce #true if image is wide/tall/square.

(check-expect (wide? I1) false)
(check-expect (wide? I2) true)
(check-expect (tall? I3) true)
(check-expect (tall? I4) false)
(check-expect (square? I1) false)
(check-expect (square? I2) false)
(check-expect (square? I5) true)

(define (wide?   img) (> (image-width img) (image-height img)))
(define (tall?   img) (< (image-width img) (image-height img)))
(define (square? img) (= (image-width img) (image-height img)))


(: area (Image -> Number))
;; Produce area of image (width * height).

(check-expect (area I1) 200)
(check-expect (area I2) 600)

(define (area img)
  (* (image-width img)
     (image-height img)))


(check-expect (map positive? (list 1 -2 3 -4)) (list true false true false))
(check-expect (filter negative? (list 1 -2 3 -4)) (list -2 -4))
(check-expect (foldr + 0 (list 1 2 3)) (+ 1 2 3 0))
(check-expect (foldr * 1 (list 1 2 3)) (* 1 2 3 1))
(check-expect (build-list 6 identity) (list 0 1 2 3 4 5))
(check-expect (build-list 4 sqr) (list 0 1 4 9))


; 
; PROBLEM
; 
; Complete the design of the following functions by coding them using a 
; built-in abstract list function.
; 


(: wide-only ((ListOf Image) -> (ListOf Image)))
;; Produce list of only those images that are wide?.

(check-expect (wide-only (list I1 I2 I3 I4 I5)) (list I2 I4))

(define (wide-only loi)
  (filter wide? loi))


(: all-tall? ((ListOf Image) -> Boolean))
;; Produce #true if all the images in loi are tall?.

(check-expect (all-tall? LOI1) #f)
(check-expect (all-tall? (list I1 I3)) #t)

(define (all-tall? loi)
  (andmap tall? loi))


(: sum ((ListOf Number) -> Number))
;; Produce the sum of the elements of a list.

(check-expect (sum (list 1 2 3 4)) 10)

(define (sum lon)
  (foldr + 0 lon))


(: sum-to (Natural -> Natural))
;; Produce the sum of the first n natural numbers.

(check-expect (sum-to 4) (+ 0 1 2 3))

(define (sum-to n)
  (foldr + 0 (build-list n identity)))