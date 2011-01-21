#lang slideshow

(require slideshow/code)

(slide #:title "Racket - a crash course")

(slide #:title "What is Racket?"
       (t "Scheme with useful libraries")
       (t "(plus some other stuff)"))
(slide #:title "DrRacket howto"
       ; definitions window
       ; interactions window
       ; help desk
       )
(slide #:title "Command-line Racket howto"
       #;(item "Add to $PATH if necessary")
       #;(item "Why the errors?"))
(slide #:title "Scheme Basics"
       'next
       (para "s-expressions:")
       'next
       (item "atoms"
             (item "numbers")
             (item "arrays")
             (item "strings")
             (item "symbols"))
       ; what is #:title? is that an addition by Racket?
       ; identifiers are symbols, right?
       'next
       (item "lists")
       'next
       (t "Yes, this really is all there is."))
(slide #:title "Scheme Basics"
       (para "Lists:"
             (item (tt "empty"))
             (item "A pair of a value and a list")))
(slide #:title "Scheme Basics"
       (para "List construction:"
             (item (tt "(cons") (it "value list") (tt ")"))
             (item (tt "(list") (it "value") (tt "...)"))))
(slide #:title "Scheme Basics"
       (para "Function definition:")
       (item (tt "(λ (")
             (it "formal")
             (tt "...)")
             (it "body-expr")
             (tt "...)"))
       (item (tt "(lambda (")
             (it "formal")
             (tt "...)")
             (it "body-expr")
             (tt "...)")))
(slide #:title "Scheme Basics"
       (item (tt "(define") (it "name value") (tt ")"))
       (item (tt "(let ([")
             (it "name value")
             (tt "] ...)")
             (it "body ...")
             (tt ")")))
(slide #:title "Putting it all together"
       (item ""))
(slide #:title "List operations"
       (item (tt "(map)"))
       (item (tt "(foldl)")))
(slide #:title "Module System"
       ; maybe show racket doc to demonstrate how to know what to import
       (para (tt "(require") (it "module") (tt ")")))
(slide #:title "(read)"
       (para (begin
                (write (list 1 2 3))
                (printf "~n")
                (define temp-file (build-path (current-directory) "temp"))
                (with-output-to-file #:exists 'replace temp-file
                  (λ () (write (list 1 2 3))))
                (define my-list (with-input-from-file temp-file read))
                (first my-list)
                (second my-list)
                (third my-list)
                (delete-file temp-file))))
(slide #:title "match construct and quasiquotes")
(slide #:title "regular expressions")
(slide #:title "structs")

(slide)