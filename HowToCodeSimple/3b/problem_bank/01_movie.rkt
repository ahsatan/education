;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 01_movie) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM A
; 
; Design a data definition to represent a movie, including  
; title, budget, and year released.
; 
; To help you to create some examples, find some interesting movie facts below: 
; "Titanic" - budget: 200000000 released: 1997
; "Avatar" - budget: 237000000 released: 2009
; "The Avengers" - budget: 220000000 released: 2012
; 
; However, feel free to resarch more on your own!
; 


;; (MovieOf (String Natural Natural))
(define-struct movie (title budget release-year))
;; interp. Movie details.

(define M1 (make-movie "Titanic" 200000000 1997))
(define M2 (make-movie "Avatar" 237000000 2009))

#;
(define (fn-for-movie m)
  (... (movie-title m)
       (movie-budget m)
       (movie-release-year m)))


; 
; PROBLEM B
; 
; You have a list of movies you want to watch, but you like to watch your 
; rentals in chronological order. Design a function that consumes two movies 
; and produces the title of the most recently released movie.
; 


(: last? (Movie Movie -> String))
;; Produce the movie that was released last, chronologically.

(check-expect (last? M1 M2) (movie-title M2))
(check-expect (last? M2 M1) (movie-title M2))

(define (last? m1 m2)
  (if (> (movie-release-year m1) (movie-release-year m2))
      (movie-title m1)
      (movie-title m2)))