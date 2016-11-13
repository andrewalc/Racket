;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname |Week 11 Set A|) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp")) #f)))
; Andrew Alcala alcala.a@husky.neu.edu
; Jeffrey Champion champion.j@husky.neu.edu
;------------------------------------------------------------------------------
; PROBLEM SET 11 A
;------------------------------------------------------------------------------
; DATA DEFINITIONS:
;------------------------------------------------------------------------------
; A [List of X] is one of:
; '()
; (cons X [List-of X])

; A N is one of: 
; – 0
; – (add1 N)
; interpretation represents the counting numbers

(define-struct table [length array])
; A Table is a structure:
; (make-table N [N -> Number])
; Examples:
(define (f1 x)
  (local [(define a (lambda (y) (- (* y y) 36)))]
    (a x)))
(define table1 (make-table 5 f1))

; N -> Number
(define (f2 i)
  (if (= i 0)
      pi
      (error "table2 is not defined for i =!= 0")))
(define table2 (make-table 1 f2))

(define (f3 x)
  (local [(define a (lambda (y) (-(* y y)5)))]
    (a x)))
(define table3 (make-table 7 f3))

(define (f4 x)
  (local [(define a (lambda (y) (+ (* y y) 1)))]
    (a x)))
(define table4 (make-table 5 f4))

;------------------------------------------------------------------------------
; FUNCTIONS:
;------------------------------------------------------------------------------
; Table N -> Number
; looks up the ith value in array of t
(define (table-ref t i)
  (local ((define array (table-array t)))
    (array i)))

; find-linear: Table -> Number
; find-linear: Finds the smallest index for a root of the table.
(check-expect (find-linear table1) 5)
(check-expect (find-linear table2) 0)
(check-expect (find-linear table3) 2)
(check-expect (find-linear table4) 0)

(define (find-linear t)
  (local ((define max  (table-length t))
          (define (closer n1 n2)
            (< (abs n1) (abs n2)))
          (define (find t i m)
            (cond [(< max 2) i]
                  [(> i max) m]
                  [(closer (table-ref t i) (table-ref t m))
                   (find (make-table max (table-array t)) (add1 i) i)]
                  [else (find (make-table max (table-array t)) (add1 i) m)])))
    (find t 0 0)))

; find-binary: Table -> Number
; find-binary: finds the smallest index for root of a monotonically increasing
; table but uses generative recursion to do so
(check-expect (find-binary table1) 5)
(check-expect (find-binary table2) 0)
(check-expect (find-binary table3) 2)
(check-expect (find-binary table4) 0)
(define (find-binary t)
  (local ((define c .1)
          ; [Number -> Number] Number Number -> Number
          ; determines R such that f has a root in [R,(+ R c)] 
          ; if 0 is not in the interval, returns the endpoint closer to 0
          (define (find-root f left right)
            (cond
              [(< right 2) 0]
              [(<= (- right left) c) left]
              [else
               (local ((define mid (/ (+ left right) 2))
                       (define f@mid (f mid)))
                 (cond
                   [(or (<= (f left) 0 f@mid) (<= f@mid 0 (f left)))
                    (find-root f left mid)]
                   [(or (<= f@mid 0 (f right)) (<= (f right) 0 f@mid))
                    (find-root f mid right)]
                   [else (if(< (abs (f left)) (abs (f right)))
                            left right)]))])))
    (round (find-root (table-array t) 0 (table-length t)))))
;------------------------------------------------------------------------------          