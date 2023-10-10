;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P2_photos) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; (PhotoOf String String Boolean)
(define-struct photo (location album favorite))
;; interp. Photo with location, album, and favorite status.

(define PHT1 (make-photo "photos/2012/june" "Victoria" #t))
(define PHT2 (make-photo "photos/2013/birthday" "Birthday" #t))
(define PHT3 (make-photo "photos/2012/august" "Seattle" #t))
(define PHT4 (make-photo "photos/2014/birthday" "Birthday" #f))


; 
; PROBLEM
; 
; Design a function called to-frame that consumes an album name and a list of photos 
; and produces a list of only those photos that are favourites and belong to 
; the given album.
; 


(: to-frame (String (ListOf Photo) -> (ListOf Photo)))
;; Produce the sub-list of photos that are favorites and belong to the given album.

(check-expect (to-frame "Birthday" (list PHT1)) empty)
(check-expect (to-frame "Birthday" (list PHT1 PHT2 PHT3)) (list PHT2))
(check-expect (to-frame "Birthday" (list PHT2 PHT4)) (list PHT2))

(define (to-frame s lop)
  (local [(define (include? p) (and (photo-favorite p)
                                    (string=? s (photo-album p))))]
    (filter include? lop)))