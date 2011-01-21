#lang slideshow

(require slideshow/code)

(slide #:title "What is Racket? (vs. Scheme)")
(slide #:title "DrRacket howto")
(slide #:title "Command-line Racket howto"
       (item "Add to $PATH if necessary")
       (item "Why the errors?"))
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
(slide #:title "Scheme Basics: constructing lists"
       (item (tt "(cons") (it "value list") (tt ")"))
       (item (tt "(list") (it "value ...") (tt ")")))
(slide #:title "Scheme Basics: define")
(slide #:title "Scheme Basics: lambda")
(slide #:title "Scheme Basics: let")
(slide #:title "Putting it all together"
       (item ""))
(slide #:title "module system")
(slide #:title "quasiquotes")
(slide #:title "read procedure")
(slide #:title "match construct")
(slide #:title "regular expressions")
(slide #:title "structs")

(slide)