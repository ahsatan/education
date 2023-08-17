;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname BSL_P8_cflag) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; The background for the Canadian Flag (without the maple leaf) is this:
;          .
;          
; Write an expression to produce that background. (If you want to get the
; details right, officially the overall flag has proportions 1:2, and the 
; band widths are in the ratio 1:2:1.)
; 


(require 2htdp/image)

(define BASE_WIDTH 20)
(define HEIGHT (* BASE_WIDTH 2))

(beside (rectangle BASE_WIDTH HEIGHT "solid" "red")
        (rectangle (* BASE_WIDTH 2) HEIGHT "solid" "white")
        (rectangle BASE_WIDTH HEIGHT "solid" "red"))