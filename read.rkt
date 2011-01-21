#lang racket

(write (list 1 2 3))
(printf "~n")
(define temp-file (build-path (current-directory) "temp"))
(with-output-to-file #:exists 'replace temp-file (λ () (write (list 1 2 3))))
(define my-list (with-input-from-file temp-file read))
(first my-list)
(second my-list)
(third my-list)
(delete-file temp-file)