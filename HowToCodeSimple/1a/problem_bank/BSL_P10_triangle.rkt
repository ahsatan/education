;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname BSL_P10_triangle) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Write an expression that uses triangle, overlay, and rotate to produce an image similar to this:
; 
;                                   .
; 


(require 2htdp/image)

(overlay (triangle 50 "solid" "green")
         (rotate 180 (triangle 50 "solid" "yellow")))