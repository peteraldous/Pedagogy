#lang racket

(define (test expected actual)
  (cond [(equal? expected actual)
         (void)]
        [else
         (error 'calc "expected ~a, got ~a" expected actual)]))

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
    [`(,a / ,b) (/ (calc a) (calc b))]
    [else (error 'calc "Could not parse ~e" exp)]))

(test 3 (calc '(1 + 2)))
(test 2 (calc '(1 * 2)))
(test -1 (calc '(1 - 2)))
(test 2 (calc '(2 / 1)))
(test 2 (calc '(1 + (6 - 5))))