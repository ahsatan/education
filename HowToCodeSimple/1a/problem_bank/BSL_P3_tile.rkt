;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname BSL_P3_tile) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Use the DrRacket square, beside, and above functions to create an image like this one:
; 
; .
; 


(require 2htdp/image)

(define (subtile color) (square 20 "solid" color))

(define SUBTILE_PRIMARY (subtile "blue"))
(define SUBTILE_SECONDARY (subtile "yellow"))

(above (beside SUBTILE_PRIMARY SUBTILE_SECONDARY)
       (beside SUBTILE_SECONDARY SUBTILE_PRIMARY))