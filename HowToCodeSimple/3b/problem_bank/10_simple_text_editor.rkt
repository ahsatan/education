;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname 10_simple_text_editor) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;  
;  Design a simple one-line text editor.
;  
;  Your text editor should have the following functionality:
;  - when you type, characters should be inserted on the left side of the cursor 
;  - when you press the left and right arrow keys, the cursor should move accordingly  
;  - when you press backspace (or delete on a mac), the last character on the left of 
;    the cursors should be deleted
;  


(require 2htdp/image)
(require 2htdp/universe)
(define Image (signature (predicate image?)))
(define KeyEvent (signature (predicate key-event?)))

(define WIDTH 300)
(define HEIGHT 20)
(define CENTER-X (/ WIDTH 2))
(define CENTER-Y (/ HEIGHT 2))
(define MTS (empty-scene WIDTH HEIGHT "midnight blue"))
(define CURSOR (rectangle 2 14 "solid" "red"))
(define TEXT-SIZE 14)
(define TEXT-COLOR "orange")


;; (EditorOf (String String))
(define-struct editor (pre post))
;; interp. Pre is the text before the cursor, post is the text after.

(define E0 (make-editor "" ""))
(define E1 (make-editor "a" ""))
(define E2 (make-editor "" "b"))

#;
(define (fn-for-editor e)
  (... (editor-pre e)
       (editor-post e)))


;; Render a single-line text editor with a moveable cursor and backspace functionality.
;; Start with (main (make-editor "" "")).
(define (main e)
  (big-bang e
    (to-draw render)
    (on-key handle-key)))


(: render (Editor -> Image))
;; Draw the pre and post text with the cursor in between.

(check-expect (render E1) (place-image (beside (text "a" TEXT-SIZE TEXT-COLOR)
                                               CURSOR
                                               (text "" TEXT-SIZE TEXT-COLOR))
                                       CENTER-X
                                       CENTER-Y
                                       MTS))
(check-expect (render E2) (place-image (beside (text "" TEXT-SIZE TEXT-COLOR)
                                               CURSOR
                                               (text "b" TEXT-SIZE TEXT-COLOR))
                                       CENTER-X
                                       CENTER-Y
                                       MTS))

(define (render e)
  (place-image (beside (text (editor-pre e) TEXT-SIZE TEXT-COLOR)
                       CURSOR
                       (text (editor-post e) TEXT-SIZE TEXT-COLOR))
               CENTER-X
               CENTER-Y
               MTS))


(: handle-key (Editor KeyEvent -> Editor))
;; Add a typed character to pre, navigate left or right using arrow keys,
;;   or delete the last pre character with backspace.

(check-expect (handle-key (make-editor "ab" "cd") "left") (make-editor "a" "bcd"))
(check-expect (handle-key (make-editor "ab" "cd") "right") (make-editor "abc" "d"))
(check-expect (handle-key E1 "c") (make-editor "ac" ""))
(check-expect (handle-key (make-editor "ab" "cd") "\b") (make-editor "a" "cd"))

(define (handle-key e ke)
  (cond [(key=? "\b" ke) (make-editor (trim-last-char (editor-pre e)) (editor-post e))]
        [(key=? "left" ke) (make-editor (trim-last-char (editor-pre e))
                                        (string-append (last-char (editor-pre e)) (editor-post e)))]
        [(key=? "right" ke) (make-editor (string-append (editor-pre e) (first-char (editor-post e)))
                                         (trim-first-char (editor-post e)))]
        [(= 1 (string-length ke)) (make-editor (string-append (editor-pre e) ke) (editor-post e))]
        [else e]))


(: trim-first-char (String -> String))
;; Produce the given string minus the first character for length >= 1 or "" for empty string.

(check-expect (trim-first-char "") "")
(check-expect (trim-first-char "a") "")
(check-expect (trim-first-char "abc") "bc")

(define (trim-first-char s)
  (if (> (string-length s) 0)
      (substring s 1)
      s))


(: trim-last-char (String -> String))
;; Produce the given string minus the last character for length >= 1 or "" for empty string.

(check-expect (trim-last-char "") "")
(check-expect (trim-last-char "a") "")
(check-expect (trim-last-char "abc") "ab")

(define (trim-last-char s)
  (if (> (string-length s) 0)
      (substring s 0 (- (string-length s) 1))
      s))


(: first-char (String -> String))
;; Produce the first character in a string with a length >= 1 or "" for empty string.

(check-expect (first-char "") "")
(check-expect (first-char "a") "a")
(check-expect (first-char "abc") "a")

(define (first-char s)
  (if (> (string-length s) 0)
      (substring s 0 1)
      s))


(: last-char (String -> String))
;; Produce the last character in a string with a length >= 1 or "" for empty string.

(check-expect (last-char "") "")
(check-expect (last-char "a") "a")
(check-expect (last-char "abc") "c")

(define (last-char s)
  (if (> (string-length s) 0)
      (substring s (- (string-length s) 1) (string-length s))
      s))


#;
(main (make-editor "" ""))