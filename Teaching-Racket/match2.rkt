#lang racket

; (a + b)
; (a - b)
; (a * b)
; (a / b)

(define (calc exp)
  (match exp 
    [(? number?) exp]
    [`(,a + ,b) (+ (calc a) (calc b))]
    [`(,a - ,b) (- (calc a) (calc b))]
    [`(,a * ,b) (* (calc a) (calc b))]
    [`(,a / ,b) (if (zero? (calc b))
                    (error "You can't divide by zero!")
                    (/ (calc a) (calc b)))]
    [else (error "what is this?")]))

(calc '(1 + 2))
(calc '(2 - 1))
(calc '(3 * 4))
(calc '(4 / 2))