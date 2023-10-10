;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P1_wide_only) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(define Image (signature (predicate image?)))

; 
; PROBLEM
; 
; Use the built in version of filter to design a function called wide-only 
; that consumes a list of images and produces a list containing only those 
; images that are wider than they are tall.
; 


(: wide-only ((ListOf Image) -> (ListOf Image)))
;; Produce a sub-list of images that are wider than they are tall.

(check-expect (wide-only (list (rectangle 10 20 "solid" "blue")
                               (rectangle 20 10 "solid" "green")
                               (square 10 "solid" "yellow")
                               (rectangle 30 20 "solid" "orange")))
              (list (rectangle 20 10 "solid" "green")
                    (rectangle 30 20 "solid" "orange")))

(define (wide-only loi)
  (local [(define (wide? i) (> (image-width i) (image-height i)))]
    (filter wide? loi)))