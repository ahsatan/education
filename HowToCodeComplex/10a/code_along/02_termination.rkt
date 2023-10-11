;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname 02_termination) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; .
; 
; ; 
; ; The Collatz conjecture is a conjecture in mathematics named
; ; after Lothar Collatz, who first proposed it in 1937.
; ; The sequence of numbers involved is referred to as the hailstone 
; ; sequence or hailstone numbers (because the values are usually 
; ; subject to multiple descents and ascents like hailstones in a 
; ; cloud). 
; ; 
; ; f(n) = /   n / 2   if n is even
; ;        \   3n + 1  if n is odd 
; ; 
; ; The Collatz conjecture is: This process will eventually reach
; ; the number 1, regardless of which positive integer is chosen
; ; initially.       
; ; 
; 
; 
; [Image and part of text from: https://en.wikipedia.org/wiki/Collatz_conjecture]
; 



;; Integer[>=1] -> (listof Integer[>=1])
;; Produce hailstone sequence for n.

(check-expect (hailstones 1) (list 1))
(check-expect (hailstones 2) (list 2 1))
(check-expect (hailstones 4) (list 4 2 1))
(check-expect (hailstones 5) (list 5 16 8 4 2 1))

(define (hailstones n)
  (if (= n 1) 
      (list 1)
      (cons n 
            (if (even? n)
                (hailstones (/ n 2))
                (hailstones (add1 (* n 3)))))))


; 
; PROBLEM
; 
; The s-tri, s-car and hailstones functions use generative recursion. So
; they are NOT based on a well-formed self-referential type comment. How do
; we know they are going terminate? That is, how do we know every recursion 
; will definitely stop? 
; 
; Construct a three part termination argument for stri.
; 
; Base case: (<= n TRI-MIN)
; 
; Reduction step: (/ n 2)
; 
; Argument that repeated application of reduction step will eventually 
; reach the base case: If MIN > 0, then as n is always halving it will always reduce to <= MIN.
; 



; 
; PROBLEM
; 
; Construct a three part termination argument for scarpet.
; 
; Base case: (<= n CAR-MIN)
; 
; Reduction step (next problem): (/ n 3)
; 
; Argument that repeated application of reduction step will eventually 
; reach the base case: Same as s-tri except n is reducing faster.
; 



; 
; PROBLEM
; 
; Construct a three part termination argument for hailstones.
; 
; Base case: (= n 1)
; 
; Reduction step (next problem): f(n) = /   n / 2   if n is even
;                                       \   3n + 1  if n is odd 
; 
; Argument that repeated application of reduction step will eventually reach the
; base case: n / 2 gets smaller approaching 1.  3n + 1 (as far as we know) eventually
; reaches a power of 2 which reduces based on the first part but it's not yet proven.
; 
; TRICK PROBLEM!
; 
